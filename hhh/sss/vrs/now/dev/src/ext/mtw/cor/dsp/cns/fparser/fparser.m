% PAR = FPARSER('M-file',['OPT',...,'OPT',...])
% PAR = FPARSER('command_line','-c',['OPT',...,'OPT',...])
%
% 		to parse a M-file or command line
% 		and list tokens and constructs
% 		- functions/keywords
% 		- variables/constants
% 		- struct field assignments
%
% OPT		option flags/arguments
% -c	:	input is a command-line
% -d	:	show results at run-time
%
% PAR		output struct with fields
% .tmpl		lexical		engine templates
% .file		file		name
% .buff		file		contents
% .skel		file		contents	after removal of
% 						var class tokens
% .res		RESULTS				[show at run-time: <-d>]
% .nline	nr of		lines
% .linx		indices		eol/lnr
% .nent		nr of		tokens		found
% .nmtok	nr of		FUNCTIONS	found
% .mtok		list of		FUNCTIONS
% .nvtok	nr of		VARIABLES	found
% .vtok		list of		VARIABLES
% .nstok	nr of		STRUCT.FIELD	assignments
% .stok		list of		STRUCT.FIELD	assignments
%
% contents of sorted token list cells
% .mtok		{'token' 'source'     name_len nr_used inx_lst lin_lst}
% .vtok		{'token' 'type'       name_len nr_used inx_lst lin_lst}
% .stok		{'token' 'contructor' name_len line_nr inx_lst lin_lst}
%
% contents of <inx_lst>s
% 		nr_used indices
% 			[beg1 ... begN	= buffer offset beg
% 			 end1 ... endN]	= buffer offset end
% 		into par.buff where tokenX was found
% contents of <lin_lst>s
% 		nr_used indices
% 			[lnr1 ... lnrN	= line number
% 			 beg1 ... begN	= line offset beg
% 			 end1 ... endN]	= line offset end
% 		of the file contents where tokenX was found
%
% USAGE EXAMPLE
%	see accompanying html-file <fpatdemo.html>

% this option is not implemented in final version!
% mod:	modify default templates			[def: par.tmpl]
%	'[xyz]'	:	do NOT delete characters	<x><y><z>
%	'{xyz}'	:	delete additional characters	<x><y><z>

% created:
%	us	10-Jun-2001		/ project <alias>
% modified:
%	us	12-Dec-2005 09:26:17	/ CSSM/TMW

function	olst=fparser(varargin)

			mod=[];
			mode=0;
			lst=ini_lst(varargin{:});
	if	nargout
			olst=lst;
	end
	if	nargin < 1 | isempty(varargin{1})
			help(mfilename);
			return;
	end

			var=varargin{1};
% command line
	if	nargin > 1 & lst.par.opt.cflg
			lst.file='command line';
			lst.type='string';
			mode=1;
			var=[var char(10)];
% m-file
	else
			lst.file=var;
			lst.type='file';
			mode=1;
			[fp,msg]=fopen(var,'rt');
	if	fp > 0
			var=fread(fp,'uchar');
			fclose(fp);
			var=char(var).';
	else
			disp(sprintf('fparser> cannot open <%s>',var));
			disp(sprintf('.......> %s',msg));
			return;
	end
	end
% build empty output parameter struct
			lst.buff=var;
			lst.skel=var;
			lst.res='no tokens';
			linx=[0 find(var==10)];
			lst.nline=length(linx)-mode;
			lst.linx=[linx; 1:lst.nline+1];
			lst.linx(end,end)=nan;
			lst.nent=0;
			lst.nmtok=0;	% functions
			lst.mtok={};
			lst.mtxt=[];
			lst.nvtok=0;	% variables
			lst.vtok={};
			lst.vtxt=[];
			lst.nstok=0;	% struct assignments
			lst.stok={};
			lst.stxt=[];
%--------------------------------------------------------------------------------
%	templates
%	- special characters
%			tmpls='@._';
%	- unconditional:
%			tmpl1='=+-*/^''[](){},.:;\~!#$%&|<>?"`';
			tmpl1='=+-*/^''[](){},:;\~!#$%&|<>?"`';
%	- space both | right | surrounded by chars
			tmpl2='@';
%	- space both | left
			tmpl3='0123456789';

			iinc=[];
			idel=[];
	if	nargin > 1 & ~isempty(mod)
			ib=strfind(mod,'[');
		if	~isempty(ib)
			ie=strfind(mod,']');
		if	~isempty(ie)
			iinc=mod(ib+1:ie-1);
		end
		end
			ib=strfind(mod,'{');
		if	~isempty(ib)
			ie=strfind(mod,'}');
		if	~isempty(ie)
			idel=mod(ib+1:ie-1);
		end
		end
%D			disp(sprintf('inc: <%s>',iinc));
%D			disp(sprintf('del: <%s>',idel));
		for	i=1:length(iinc)
			tmpl1(find(iinc(i)==tmpl1))='';
			tmpl2(find(iinc(i)==tmpl2))='';
			tmpl3(find(iinc(i)==tmpl3))='';
		end
			tmpl1=[tmpl1 idel];
	end
			dflg=1;
	if	nargin > 2
			lst.par.opt.dflg=1;
	end
%			tmpl3=[tmpl3 tmpl3];
			vari=var;
			lst.tmpl.tmpl1=tmpl1;
			lst.tmpl.cused=setdiff(char(32:128),tmpl1);
			lst.tmpl.tmpl2=tmpl2;
			lst.tmpl.tmpl3=tmpl3;
			lst.tmpl.inc=iinc;
			lst.tmpl.del=idel;
%--------------------------------------------------------------------------------
% MAIN LEXICAL ENGINE
%--------------------------------------------------------------------------------
%D			disp('***** special constructs *****');
			[lst,var,sok]=get_stri(lst,var);
			[lst,var,sok]=get_comm(lst,var,'%',10);
			[lst,var,sok]=get_stru(lst,var,'.',tmpl1);
			var=[' ' var ' '];
%--------------------------------------------------------------------------------
%D			disp('***** punctuations *****');

	for	i=1:length(tmpl1)
			var=strrep(var,tmpl1(i),' ');
%D			disp(var)
	end

	for	i=1:length(tmpl2)
			ix=strfind(var,tmpl2(i));
		if	~isempty(ix)
% space both
			iy=find(var(ix+1)==' ' & var(ix-1)==' ');
			var(ix(iy))=' ';
% char both | left
			iy=[...
				find((var(ix+1)~=' ' & var(ix-1)~=' ') | ...
				(var(ix-1)~=' '))...
			];
		if	~isempty(iy)
			ixo=ix;
			iyo=iy;
			ix=ix(iy);	% -1
			var(ix)=' ';	% '|'
			nc=0;
% erode ->
		while	iy
			nc=nc+1;
			iy=find(var(ix+nc)~=' ');
			var(ix(iy)+nc)=' ';
			ix=ix(iy);
		end
			ix=ixo;
			iy=iyo;
			nc=0;
% erode <-
		while	iy
			nc=nc+1;
			iy=find(var(ix-nc)~=' ');
			var(ix(iy)-nc)=' ';
			ix=ix(iy);
		end
		end
		end
%			disp(var);
	end
%--------------------------------------------------------------------------------
%D			disp('***** numbers *****')
% must use an eroding process!
			vart=var;
	while	true
	for	i=1:length(tmpl3)
			ix=find(var==tmpl3(i));
		if	~isempty(ix)
% space left
			iy=find(isspace(var(ix-1)));
			var(ix(iy))=' ';
% space both
			iy=find(isspace(var(ix+1)) & isspace(var(ix-1)));
			var(ix(iy))=' ';
		end
%D			disp(var);
	end
	if	isequal(var,vart)
			break;
	end
			vart=var;
	end
%--------------------------------------------------------------------------------
%D			disp('***** tokens *****')
			tok={};
			emp={};
			tc={};
			var=var(2:end-1);
			b=var;
			trep=0;
			tnew=0;
			tent=0;
			[tc,b,tcp]=astrtok(b);
			tent=size(tc,1);
			tc=unique(tc);
			ix=xor(cellfun('isempty',tc),1);
			tc=tc(ix);

	for	cc=1:size(tc,1)
			a=tc{cc};
%D			disp(sprintf('%s: searching',a));
	if	(~isempty(tok) & ~isempty(strmatch(a,tok(:,1),'exact'))) | ...
		(~isempty(emp) & ~isempty(strmatch(a,emp(:,1),'exact')))
			trep=trep+1; 
%D			disp(sprintf('repeat token %5d:%5d/%5d <%s>',trep,tnew,trep+tnew,a));
			continue;
	end
			tnew=tnew+1; 
			w=[];		% keep this!
	if	~isempty(w)
			emp=[emp;{a w.class length(a)}];
	else
			p=evalin('base',sprintf('which(''%s'')',a));
		if	strcmp(p,'variable')
			p=[];
		end
		if	~isempty(p)
		if	iskeyword(a)
			p='keyword';
		end
%D			disp(sprintf('%s: PATH  <%s>',a,p));
			tok=[tok;{a p length(a)}];
		else
		if	a(1)=='@' & length(a) > 1
			emp=[emp;{a class(eval(a)) length(a)}];
		else
			emp=[emp;{a class(a) length(a)}];
		end
		end
	end	% token not in tables
	end

			varo=var;
	if	~isempty(emp)
			ix=strmatch('@',emp(:,1));
		if	~isempty(ix)
			tlen=[size(tok,1)+1:size(tok,1)+length(ix)];
			tok(tlen,:)=emp(ix,:);
			emp(ix,:)=[];
		end
		if	~isempty(tok)
			[dum,ix]=unique(tok(:,1));
			tok=tok(ix,:);
		end
			[var,tcp,tok]=fill_pattern(var,tcp,tok,'+');
			[dum,ix]=unique(emp(:,1));
		if	~isempty(emp)
			emp=emp(ix,:);
			[var,tcp,emp]=fill_pattern(var,tcp,emp,'-');
			ix=strfind(var,'-');
		if	~isempty(ix)
			var=varo;
			var(ix)=' ';
		end
		else
			var=varo;
		end
	elseif	~isempty(tok)
			[dum,ix]=unique(tok(:,1));
			tok=tok(ix,:);
			[dum,tcp,tok]=fill_pattern(var,tcp,tok,'+');
	end
%--------------------------------------------------------------------------------
			lst=set_var(lst,var,tok,emp,sok);
			lst=set_stru(lst);
			lst=show_ent(lst);
	if	nargout
			olst=lst;
	end
	if	lst.par.opt.dflg
			disp(lst.res);
	end
			return;
%--------------------------------------------------------------------------------
function	[var,tcp,tmpl]=fill_pattern(var,tcp,tmpl,pat)

		[ts,tx]=sort([tmpl{:,3}]);
		tmpl=tmpl(tx,:);
	for	i=size(tmpl,1):-1:1		% reverse search!
		s=tmpl{i,1};
%D		disp(sprintf('%s: CLR  <%s>',var,s));
		six=strmatch(s,tcp.u(:,1),'exact');
		ix=tcp.u{six,end};
		tmpl{i,4}=size(ix,2);
		tmpl{i,5}=ix;
		var=astrrepx(var,pat,ix);
%D		disp(sprintf('%s: DONE <%s>',var,s));
	end
		return;
%--------------------------------------------------------------------------------
function	[lst,tok,var]=set_var(lst,buf,tok,var,sok)

	if	~isempty(sok)
		sokt=sok;
	for	i=1:size(sok,1)
		n=sok{i,1};
		o=n;
		nnew=1;
		nlen=0;
	if	n(1) == '.'
		nnew=0;
	else
		ix=find(n=='.');
		n=n(1:ix-1);
		n=get_bracket(n);
	if	isstruct(n)
		n=n.s;
	end
		nlen=length(n)+1;
		o=o(ix:end);
		ix=find(n=='|');
	if	~isempty(ix)
		n=n(1:ix(1)-1);
	end
	end

	if	nnew
	if	~isempty(var)
		ix=strcmp(var(:,1),n);
	end
	if	~isempty(find(ix))
		p=sok{i,6};
		var{ix,4}=size(var{ix,5},2);
		var{ix,5}=[var{ix,5} p];
	else
		sok{i,1}=n;
		sok{i,2}='struct';
		sok{i,4}=length(n);
		var=[var;sok(i,[1 3:6])];
	end
	end
	end
		sok=sokt;
	end

	if	~isempty(tok)
		[dum,ix]=sort(tok(:,1));
		tok=tok(ix,:);
		tok=get_line(lst,tok);
	end
	if	~isempty(var)
		[dum,ix]=sort(var(:,1));
		var=var(ix,:);
		var=get_line(lst,var);
	end
	if	~isempty(sok)
		[dum,ix]=sort(sok(:,1));
		sok=sok(ix,:);
		sok=sok(:,[1 3:6]);
		sok=get_line(lst,sok);
	end

		lst.skel=buf;
		lst.nmtok=size(tok,1);
		lst.mtok=tok;
		lst.nvtok=size(var,1);
		lst.vtok=var;
		lst.nstok=size(sok,1);
		lst.stok=sok;
		lst.nent=lst.nmtok+lst.nvtok+lst.nstok;
		return;
%--------------------------------------------------------------------------------
function	tok=get_line(lst,tok)

	if	isempty(lst.linx)
		return;
	end
	for	i=1:size(tok,1)
		p=tok{i,5};
		l=ones(3,size(p,2));
	for	j=1:tok{i,4}
		ix=find(lst.linx(1,:)>=p(1,j));
	if	~isempty(ix)
		l(:,j)=[lst.linx(2,ix(1)-1);
			[p(:,j)-lst.linx(1,ix(1)-1)]];
	end
	end
		tok{i,6}=l;
	end
		return
%--------------------------------------------------------------------------------
function	lst=show_ent(lst)

% created:
%	us	30-Aug-2003		/ CSSM/TMW <aparser>/<fparser>

		lst.res=[];
		lst.mtxt=[];
		lst.vtxt=[];
		lst.stxt=[];
	if	~lst.nent
		lst.res=sprintf('fparser> no tokens in <%s>',lst.file);
	else
		ml=[[lst.mtok{:,3}],[lst.vtok{:,3}],[lst.stok{:,3}]];
		ml=max([ml 20])+2;
		ml=max(ml,20);
		del={repmat('-',1,ml+7)};
		fm1=sprintf('%%-%d.%ds> %%5d',ml,ml);
		fm2=sprintf('%%%dd',ml-12);

		txt=[];
		txt=[txt;{sprintf(['functions/keywords ' fm2],lst.nmtok)}];
		txt=[txt;del];
	for	i=1:size(lst.mtok,1)
		tmp=sprintf(fm1,lst.mtok{i,1},lst.mtok{i,4});
		tmp=[tmp ' ' sprintf('%s',lst.mtok{i,2})];
		txt=[txt;{tmp}];
	end
		mtxt=[txt;del];
		txt=[];
		txt=[txt;{sprintf(['variables/constants' fm2],lst.nvtok)}];
		txt=[txt;del];
	for	i=1:size(lst.vtok,1)
		txt=[txt;{sprintf(fm1,lst.vtok{i,1},lst.vtok{i,4})}];
	end
		vtxt=[txt;del];
		txt=[];
		txt=[txt;{sprintf(['struct.field assmnt' fm2],lst.nstok)}];
		txt=[txt;del];
	for	i=1:size(lst.stok,1)
		tok=lst.stok{i,1};
		tok=tok(~isspace(tok));
		tmp=sprintf(fm1,tok,lst.stok{i,4});
		tmp=[tmp ' ' sprintf('%s',lst.stok{i,2})];
		txt=[txt;{tmp}];
	end
		txt=[txt;del];
		stxt=txt;
		lst.res=char([mtxt;vtxt;stxt]);
		lst.mtxt=char(mtxt);
		lst.vtxt=char(vtxt);
		lst.stxt=char(stxt);
	end
		return;
%--------------------------------------------------------------------------------
function	[lst,varo,stok]=get_stru(lst,var,tmpl,tmpl1)

		varo=var;
		stok={};
% do not parse <structures>:	<o=aparser(string,'{.}',...)>
	if	find(tmpl1==tmpl)
		return;
	end
	if	strfind(var,tmpl)
		[lst,b]=get_struct(lst,var);
		varo=b.s;
		stok=b.v;
	end
		return;
%--------------------------------------------------------------------------------
function	lst=set_stru(lst)

	if	~lst.nent
		return;
	end
		atok=[lst.mtok;lst.vtok];
	if	isempty(atok)
		return;
	end
		itok=[atok{:,5}];
	for	i=1:size(lst.stok,1)
		p=lst.stok{i,5};
		ix=find(lst.linx(1,:)-p(1)<0);
	if	~isempty(ix)
		lst.stok{i,4}=ix(end);
	end
		tok=lst.stok{i,1};
	if	tok(1) == '.'
		pix=itok(2,:)<p(1);
		jtok=itok(:,pix);
		[a,b]=sort(abs(jtok(2,:)-p(1)));
		bp=jtok(1,b(1));
		tok=lst.buff(bp:p(2));
		bx=1;
	while	length(find(tok=='(')) < length(find(tok==')')) | ...
		length(find(tok=='{')) < length(find(tok=='}')) | ...
		length(find(tok=='[')) < length(find(tok==']'))
		bx=bx+1;
		bp=jtok(1,b(bx));
		tok=lst.buff(bp:p(2));
	end
		lst.stok{i,1}=tok;
		lst.stok{i,2}='';
		lst.stok{i,3}=length(tok);
	else
		lst.stok{i,2}='';
	end
	end
	if	~isempty(lst.stok)
		[dum,ix]=sort(lst.stok(:,1));
		lst.stok=lst.stok(ix,:);
	end
		return;
%--------------------------------------------------------------------------------
function	[lst,varo,stok]=get_stri(lst,var)
		
		varo=var;
		stok={};
		[lst,b]=get_string(lst,var);
		varo=b.s;
		stok=b;
		return;
%--------------------------------------------------------------------------------
function	[lst,varo,stok]=get_comm(lst,var,commdel,eoldel)

		varo=var;
		stok={};
		ib=find(var==commdel);
	if	~isempty(ib)
		ie=find(var==eoldel);
	for	i=1:length(ib)
		ix=find(ie>=ib(i));
		varo(ib(i):ie(ix(1))-1)='%';
	end
	end
		return
%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------
% UTILITY FUNCTIONS ADDED FROM PROJECT <ALIAS>
% modified for CSSM/TMW
%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------
function	[lst,b]=get_string(lst,s,rtmpl,rr)

			magic='get_string';

	if	isstruct(s)
			b=s;
	if	isfield(s,'magic') & strcmp(getfield(s,'magic'),magic)
		if	nargin < 4
			b.k=b.r;
		else
			b.k=rr;
		end
		for	i=1:b.n
			nobj=sprintf(b.tmpl.mark,i);
			b.k=strrep(b.k,nobj,b.t{i}(2:end-1));
		end
	end
			return;
	end

			tmpl='''';
			btmpl=' ,;=({[';
	if	nargin < 3
			rtmpl='|';
	end
			n=0;
			v={};
			t={};
			sl=length(s);
			b.magic=magic;
			b.n=0;
			b.s=s;
			b.c=s;
			b.k=[];
			b.r=s;
			b.t=t;
			b.v=v;
			b.tmpl.tmpl=tmpl;
			b.tmpl.rtmpl=rtmpl;
			b.tmpl.btmpl=btmpl;
			b.tmpl.mark='_S%-1dS_';

	if	nargin < 1 | isempty(s)
			return;
	end

% remove <inner> 'STRING's
			sori=s;

	while	1
	for	i=2:ceil(sl/2)
			obr=repmat(tmpl,1,i);
			ix=strfind(s,obr);
		if	~isempty(ix)
			dix=[-1 diff(ix)];
			iy=ix(find(dix~=1));
		if	~isempty(iy)
			s=astrrepx(s,' ',[iy;iy+i-1]);
		end
		else
			break;
		end
	end
	if	strcmp(s,sori)
			break;
	end
			sori=s;
	end
% search 'STRING's
			rori=s;
			ix=strfind(s,tmpl);
	if	~isempty(ix)
			i=0;
	while	i < length(ix)-1
			i=i+1;
			j=ix(i);
			hasdel=0;
		for	k=btmpl
		if	j==1 | s(j-1)==k | isspace(s(j-1))
			hasdel=1;
			break;
		end
		end
		if	hasdel
			n=n+1;
			t=[t;{b.c(j:ix(i+1))}];
			v=[v;{b.c(j:ix(i+1)) j ix(i+1) ix(i+1)-j}];
			s(j+1:ix(i+1)-1)=rtmpl;
			rori(j+1:ix(i+1)-1)=char(0);
			i=i+1;
		end
	end
	end
	while		1
			ix=strfind(rori,[char(0) char(0)]);
		if	isempty(ix)
			break;
		end
			rori(ix)='';
	end
			b.s=s;
		if	n
			b.r=sprintf(strrep(rori,char(0),b.tmpl.mark),[1:n]);
		else
			b.r=rori;
		end
			b.n=n;
			b.t=t;
			b.v=v;
			return;
%--------------------------------------------------------------------------------
function	[lst,b]=get_struct(lst,var,tmpl1)

% we must deal with dynamic field assignments
% valid field assignments
%	var.field		var.field
%	var.(field).(field)	var.(field).(field)
%	var.(field).field	.field
%	var(...).field		.field
%	var{...}.field		.field

			magic='get_struct';
			tmpl='.';
			varo=var;
			it=0;
			tok={};
			stok={};
			b.magic=magic;
			b.n=0;
			b.s=var;
			b.c=var;
			b.t=tok;
			b.v=stok;

	if	nargin < 2 | isempty(var)
			return;
	end
			vlen=length(var);
	if	vlen == 1
			b.s=strrep(var,tmpl,'|');
			return;
	end
% <aparser!>
	if	nargin < 3
			tmpl1='=+-*/^''[](){},:;\~!#$%&|<>?"`';
	end
			tmpl2=tmpl1;
	for	i='[](){}<>'
			tmpl2(tmpl2==i)='';
	end

% mask off marker <|>
			var=strrep(var,'|',char(0));
% mask off <continuation> <parent directory> constructs
			ix=find(var(1:end-1)=='.' & var(2:end)=='.');
	if		~isempty(ix)
			var=astrrepx(var,'|',ix);
			var=astrrepx(var,'|',ix+1);
	end
			vart=var;
			k=astrtok(var);
	for	i=1:k.len
		if	strfind(k.tb{i},'||')
			k.b(k.bos(i):k.eos(i))='|';
		end
	end
			var=k.b;
			var=strrep(var,char(0),'|');
			v=get_bracket(vart);
			var=v.s;
	if	~v.eflg
			var=astrrepx(var,'x',[v.eb;v.ee]);
	end
	for	i=tmpl2
			var(vart==i)=i;
	end
	if	~v.eflg
			var(v.eb)='(';
			var(v.ee)=')';
	end
			var(vart==tmpl)=tmpl;

% mask off dynamic field assignments
			ix=find(var==tmpl);
	for	j=1:length(ix)
			px=ix(j);
			k=1;
	while	px+k<vlen & isspace(var(px+k))
			k=k+1;
	end
	if	var(px+k) == '('
			var(px+k)='X';
	while	px+k<vlen & find(var(px+k)~=')')
			k=k+1;
	end
			var(px+k)='Y';
	end
	end

	for	j=1:length(ix)
% char both
			pref=0;
			suff=0;
			px=ix(j);
			k=1;
	while	px+k<vlen & isspace(var(px+k))
			k=k+1;
	end
	if	isletter(var(px+k)) | var(px+k) == tmpl
			suff=px+k;
	end

			px=ix(j);
			k=1;
	while	px-k>1 & isspace(var(px-k))
			k=k+1;
	end
	if	px-k > 0
	if	ischar(var(px-k))	% letter | number
			pref=px-k;
	end
	end

%D			disp(sprintf('%5d %5d %5d-%5d <%s> [%d]',j,px,pref,suff,var(pref:suff),isletter(var(pref))))
% ... ok
	if	pref & suff

% search right
		while	suff<=vlen & ~isspace(var(suff)) & isempty(find(var(suff)==tmpl1))
			suff=suff+1;
		end
			suff=suff-1;
% search left
		while	pref>0 & ~isspace(var(pref)) & isempty(find(var(pref)==tmpl1))
			pref=pref-1;
		end
			pref=pref+1;

% unflag for STRICT RULE!
%		if	~isletter(var(pref)) &
%			pref=0;
%		else
%D			disp(sprintf('%5d %5d %5d-%5d <%s> [%d]',j,px,pref,suff,var(pref:suff),isletter(var(pref))))
%		end

			it=it+1;
			stok{it,1}=pref-1;
			stok{it,2}=suff-1;
	end
	end

			var=vart;
	if	it
			varz=char(' '*ones(size(var)));
		for	i=1:it
			varz=astrrepx(varz,'|',[stok{i,1:2}]'+1);
		end
			k=astrtok(varz);
			stok=cell(size(k,1),7);
			i=0;
		for	j=1:k.len
%D			disp(sprintf('%5d %5d-%5d <%s>',j,k.bos(j),k.eos(j),var(k.bos(j):k.eos(j))));
			vk=var(k.bos(j));
		if	isletter(vk) | vk(1)=='.' | vk == ' '
			tvar=strrep(var(k.bos(j):k.eos(j)),' ','');
		if	isempty(strfind(tvar,'..'))
			i=i+1;
			tok{i}=tvar;
			st=var(k.bos(j):k.eos(j));
		while	st(end) == '.' | st(end) == ')'
			st=st(1:end-1);
		end
		if	length(find(st=='(')) > length(find(st==')'))
			st(end+1)=')';
		end
			st(isspace(st))='';
			stok{i,1}=st;
			stok{i,2}='';
			stok{i,3}='field';
			stok{i,4}=length(stok{i,1});
			stok{i,5}=1;
			stok{i,6}=[k.bos(j);k.eos(j)];
		end
		end
		end
			varo(varz=='|')='|';
	end
	if	isempty(tok)
			stok={};
	end
			varo(varo==tmpl)='|';
			b.s=varo;
			b.n=size(stok,1);
			b.t=tok;
			b.v=stok;
			return;
%--------------------------------------------------------------------------------
function	b=get_bracket(k,b,flg)

			magic='get_bracket';
	if	nargin < 2 | isempty(b)
			b='()';
	end
	if	ischar(b)
			br=b;
			clear b;	% R14+!
			b.magic=magic;
			b.bron=br(1);
			b.brof=br(2);
	end
			b.s=k;
			b.c=k;
			b.err=[];
	if	nargin < 1 | isempty(k)
			b.eflg=-4;
			b.err=['no ' b.bron '...' b.brof ' found'];
			return;
	end

			b.eflg=0;
			klen=length(k);
			sz=char('_'*ones(1,klen));
			kb=length(find(k==b.bron));
			ke=length(find(k==b.brof));
	if	~kb & ~ke
			b.eflg=-3;
			b.err=['no ' b.bron '...' b.brof ' found'];
			return;
	elseif	kb > ke
			b.eflg=-2;
	elseif	kb < ke
			b.eflg=-1;
	end

			dep=0;
			depm=0;
			deps=0;
			kb=[];
			ke=[];
			zd=zeros(size(k));
			zs=zd;
	for	i=1:klen
	if	k(i)==b.bron
			dep=dep+1;
			depm=max(dep,depm);
			zd(i)=dep;
		if	dep == 1
			deps=deps+1;
			zs(i)=deps;
		end
	end
	if	k(i)==b.brof
			zd(i)=-dep;
			dep=dep-1;
		if	dep == 0
			zs(i)=-deps;
		end
	end
	end
			kb=[];
			ke=[];
			kf=[];
	for	i=1:depm+1
			kb=[kb find(zd==i)];
			ke=[ke find(zd==-i)];
			kf=[kf i*ones(size(find(zd==i)))];
	end
	if	b.eflg
		if	isempty(kb)
			kb=ke;
			kf=1;
		elseif	isempty(ke)
			ke=1;
		end
			kdlen=length(kb)-length(ke);
		if	kdlen
			ke(end:end+kdlen)=repmat(ke(end),1,kdlen+1);
		end
	end
			[kbs,kis]=sort(kb);
			kes=ke(kis);
			g=ones(size(kf));
			ix=1:length(g);
			ix=ix(1:length(kes));
	for	i=2:depm
			iy=find(diff(kes(ix))<0);
			g(ix(iy))=i;
			ix=ix(iy);
	end

			zz={};
	for	i=1:depm
			z=sz;
			ix=find(g==i);
		for	j=ix
			z(kbs(j):kes(j))=k(kbs(j):kes(j));
		end
			zz=[zz;{z}];
	end
			zz=[zz;{k}];

			b.bl=size(kbs,2);
			b.depth=depm+1;
			b.ib=kbs;
			b.ie=kes;
			b.id=g;
			b.epoch=deps;
			b.eb=find(zs>0);
			b.ee=find(zs<0);
			b.z=char(zz);
			b.zd=zd;
			b.zs=cumsum(zs);

	if	b.eflg	| (isempty(kbs) & isempty(kes))
			berr='?';
			b.err=sz;
		if	b.eflg == -1
			berr='-';
		elseif	b.eflg == -2
			berr='+';
		end
		if	isempty(kbs) & isempty(kes)
			ks=sort(find(k==b.bron | k==b.brof));
			b.err(ks(1))=berr;
		elseif	b.eflg == -2	% beg > end
			ix=find(b.zs==max(b.zs));
			b.err(ix(1))=berr;
		elseif	b.eflg == -1	% end > beg
			ix=find(b.zs>0);
			iy=find(b.c==b.brof);
			ix=setdiff(iy,ix+1);
			b.err(ix(1))=berr;
		end
	else
			b.zs(b.ee)=[1:b.epoch];
			b.s=astrrepx(b.s,'|',[b.eb;b.ee]);
	end
			return;
%--------------------------------------------------------------------------------
function	[tb,bb,tbp]=astrtok(bb,pat,cflag)

% [tb,b,tpb] = astrtok(string[,delimiter,cflag)

% created:
%	us	10-Aug-1996

	if	nargin < 2 | isempty(pat)
		pat=' ';
	end
	if	nargin < 3 | isempty(cflag)
		cflag=0;
	end
		b=bb;
		tb={};
		u={};
		bl=length(b);
		pl=min(length(pat),bl);
		len=0;
		bos=[];
		eos=[];
		los=[];

	if	~isempty(b)

		b(isspace(b))=' ';

	if	cflag
	while	1
		ix=strfind(b,'  ');
	if	isempty(ix)
		break;
	end
		b(ix)='';
	end
		b=deblank(b);
		b(strfind(b,' '))='';
	end

	if	~isempty(b)

		ix=strfind(b,pat);
		bos=[-pl+1 ix]+pl;
		los=diff([-pl+1 ix length(b)+pl])-pl;
		eos=min(bos+los-1,length(b));

		ix=find(eos>=bos);
		bos=bos(ix);
		eos=eos(ix);
		los=los(ix);
		len=length(bos);
	if	isempty(len)
		len=0;
	end

		tb={};
		tb=cell(len,1);
	for i=1:len
		tb(i)={b(bos(i):eos(i))};
	end

		[u,j,k]=unique(tb);
		tt=cell(len,1);
	for	i=1:len
		tt{i}=[bos(i) eos(i)];
	end
	for	i=1:length(j);
		tp=reshape([tt{k==i}],2,length(find(k==i)));
		u(i,4)={tp};
	end
	end	% ~isempty(len)
	end	% ~isempty(b)

		tbp.tb=tb;
		tbp.u=u;
		tbp.b=bb;
		tbp.bl=length(bb);
		tbp.pat=pat;
		tbp.pl=pl;
		tbp.len=len;
		tbp.bos=bos;
		tbp.los=los;
		tbp.eos=eos;

	if	nargout < 3
		tb=tbp;
	end

		return;
%--------------------------------------------------------------------------------
function	[so,sp]=astrrepx(s,pat,pix,opat)

% [s,sop] = astrrepx(str,npat,pix)
% [s,sop] = astrrepx(str,npat,oix,opat)
%
%	indexed string replacement:
%	str([inx11:inx12 inx21:inx22 ...])=npat
%
% str	:	input string:		class <char> | <double>
% pat	:	replacing pattern:	class <char> | <double>
%
% pix	:	index into <s>
%  (2,N):	[	beg1 beg2 ... begN
%			end1 end2 ... endN	]
%  (1,N):	[	beg1 beg2 ... begN	]
%		endX	= computed from <pat>length
%
% oix	:	index into occurrencies of <opat> in <s>
%		[]	= all occurrencies
%		[nr(s)]	= occurrencies [nr1 nr2 ... nrN]
%		 nrX	= <inf>
%			= last occurrence
%
% sop	:	replacement parameters <struct>
%
% note:
%	astrrepx only changes EXACT matches!
%
% examples:
%	s = astrrepx(s,pat,pix)
%	s = astrrepx(s,pat,oix,opat)
%
%	s = astrrepx(s,pat,[1 4 10],opat)
%	s = astrrepx(s,pat,[],opat)
%	s = astrrepx(s,pat,[1 inf],opat)

%	v='d|dd|ddd|dd|dddd|dddddd';

% created:
%	us	20-Dec-1993

		sp.pati=[];
		sp.opat=[];
		sp.pato=[];
		sp.pixi=[];
		sp.oixi=[];
		sp.nr=[];
		sp.nc=[];
		sp.pix=[];
	if	nargin < 3
		help astrrepx;
	if	nargout
		so=[];
		sp.msg='input parameters missing';
	end
		return;
	end
%--------------------------------------------------------------------------------
		so=s;
		sp.pati=pat;
		sp.msg='running ...';

	if	~strcmp(class(s),class(pat))
		disp(sprintf('astrrepx> cannot merge input classes <%s>:<%s>',class(s),class(pat)));
		sp.msg='input classes do not match';
		return;
	end
	if	~ischar(s)
		[sp.nr,sp.nc]=size(s);
		s=s(:)';
		so=s;
	end
%--------------------------------------------------------------------------------
	if	nargin > 3
		pixi=pix;
		sp.opat=opat;
		sp.pixi=pixi;
		pix=findstr(s,opat);
	if	isempty(pix)
		sp.msg='pattern not found';
		return;
	end
		pix=[pix;pix+length(opat)-1];
		pixl=size(pix,2);
	if	isempty(pixi)
		pixi=[1:pixl];
	else
		pixi=pixi(1,:);
		pixi(isinf(pixi))=pixl;
		pixi=unique(pixi(find(pixi>0 & pixi<=pixl)));
	end
		sp.opat=opat;
		sp.oixi=pixi;
		pix=pix(:,pixi);
% pattern must be <exact> !
		pixex=find(pix(1,2:end)<=pix(2,1:end-1));
		pix(:,[pixex pixex+1])=[];
	if	isempty(pix)
		sp.msg='exact pattern match not found';
		return;
	end
	end	% nargin > 3
%--------------------------------------------------------------------------------
		sp.pix=pix;
		[nr,nc]=size(pix);

	if	nr == 1
		pix=[pix;pix+length(pat)-1];
	end
	if	0
		pixx=find(pix(2,:)>0 & pix(2,:)<=length(so));
		pix=pix(:,pixx);
	end

% pattern length must be <exact> !
	if	ischar(s)
		rlen=length(pat);
		plen=pix(2,1)-pix(1,1)+1;
% allow diff pix.length in case pat.length == 1!
	if	rlen == 1
		nc=rlen;
		plen=sum(pix(2,:)-pix(1,:)+1);
	end
	if	plen < rlen
		pat=pat(1:plen);
	elseif	plen > rlen
		pat=(ones(ceil(plen/rlen),1)*pat)';
		pat=pat(1:plen);
	end
	end	% input class <char>

		rpat=(ones(nc,1)*pat)';
		pixe=pix(2,:)+1;
		pixx=find(pixe<=length(so));
		k1=zeros(size(so));
		k2=k1;
		k1(pix(1,:))=1;
		k2(pixe(pixx))=-1;
		a=logical(cumsum(k1+k2));

try
		so(a)=rpat;
catch
		disp('astrrepx> this should NOT happen!')
		disp('astrrepx> please, contact <us@neurol.unizh.ch>');
		keyboard
end
	if	~ischar(so)
		so=reshape(so,sp.nr,sp.nc);
	else
		pat=char(pat);
	end
		sp.pato=pat;
		sp.pix=pix;
		sp.msg='ok';
		return;
%--------------------------------------------------------------------------------
function	lst=ini_lst(varargin)

		lst.magic='FPARSER';
		lst.ver='12-Dec-2005 09:26:17';
		lst.time=datestr(clock);
		lst.par.mos=version;
		lst.par.rel=sscanf(version('-release'),'%d');
		lst.par.opt.cflg=0;		% input: command line
		lst.par.opt.dflg=0;		% show res at run-time
		lst.tmpl=[];
	if	nargin > 1
	if	strmatch('-c',varargin,'exact')
		lst.par.opt.cflg=1;
	end
	if	strmatch('-d',varargin,'exact')
		lst.par.opt.dflg=1;
	end
	end
		return;
%--------------------------------------------------------------------------------

