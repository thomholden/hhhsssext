function Callback_gen_data(varargin)

import java.awt.*;
import javax.swing.*;
import javax.swing.table.*;


%************************************************
% creation d'un tableau
%************************************************

panel3=varargin{3};

vp=panel3.getViewport;
vp.removeAll;
panel3.updateUI;
scrollayout=varargin{4};

u=varargin{5};
vp_table=get(scrollayout,'ViewPort');


% données à ranger dans le tableau
c=rand(100,9);
data=num2cell(c);
colname={'col1','col2','col3','col4','col5','col6','col7','col8','col9'};

%creation du Tableau

t=MyTable(data,colname); %classe tableau personnelle
%t=JTable(data,colname); 


set(t,'ColumnSelectionAllowed','on');
set(t,'cellSelectionEnabled','on');
t.setAutoResizeMode(JTable.AUTO_RESIZE_OFF); %ajoute le scrollbar horizontal
assignin('base', 't',t);
vp_table.setView(t);

vp.updateUI;
u.repaint;
u.revalidate;
