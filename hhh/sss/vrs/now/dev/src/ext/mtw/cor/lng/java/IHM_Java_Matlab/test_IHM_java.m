function test_ihm_java


clc
clear all
close all

import java.awt.*;
import java.awt.event.*;
import java.util.*;
import javax.swing.*;
import javax.swing.event.TableModelEvent;
import javax.swing.event.TableModelListener;
import javax.swing.table.*;
import javax.swing.JTabbedPane;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JFrame;
import javax.swing.JComponent;
import javax.swing.UIManager;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.KeyEvent;

import javax.swing.*;
import java.awt.*;

import java.util.Vector;


%creation du paneau principale 
%avec split panel et tree control

% 1 etape creation du tree 
% avec callback
root=TreeData('LineProperties');
    Marker=TreeData('Marker');
        triangle=TreeData('triangle');
        rectangle=TreeData('rectangle');
        rond=TreeData('rond');
    Color=TreeData('Color');
        bleu=TreeData('bleu');
        rouge=TreeData('rouge');
        vert=TreeData('vert');
    
node1=[Marker,Color];   
node_shape=[triangle,rectangle,rond];
node_color=[bleu,rouge,vert];

TreeData.linkData(root,node1);
TreeData.linkData(Marker,node_shape);
TreeData.linkData(Color,node_color);

tree=myTree(root);
tree.setShowsRootHandles(true);
%set(tree,'ValueChangedCallback','disp(''toto'')');

%tree.setAutoResizeMode(JTree.AUTO_RESIZE_OFF);
%********************
%2 etape creation des sous panels du panel principal
%********************
panel = JScrollPane; % contient l'arbre 
panel2= JPanel; % contient les tabpanels(les buttons)
panel3= JScrollPane; % contient le tableau

%****************************
%creation des layouts
%****************************
layout1=BorderLayout;
panel2.setLayout(layout1);
set(panel2,'Background',[0.53,0.53,0.53]);


scrollayout0=ScrollPaneLayout;  %creation d'un scrollayout 
panel.setLayout(scrollayout0);
panel.setMinimumSize(Dimension(100, 110));
%panel.setSize(Dimension(100, 110));


%remplissage du panel 3
%creation du scrolllayout qui contient le tableau
scrollayout=ScrollPaneLayout;  %creation d'un scrollayout 
panel3.setLayout(scrollayout); %application du scrollayout au panel 3

%remplissage des coins du scrollayout 
llcorner=JPanel;
rlcorner=JPanel;
rucorner=JPanel;
lucorner=JPanel;
panel3.setCorner(panel3.LOWER_LEFT_CORNER,llcorner); 
panel3.setCorner(panel3.LOWER_RIGHT_CORNER,rlcorner); 
panel3.setCorner(panel3.UPPER_RIGHT_CORNER,rucorner);
panel3.setCorner(panel3.UPPER_LEFT_CORNER,lucorner);

vp_table=get(scrollayout,'ViewPort'); %le vp est la fenetre centrale du scrollayout
vp_tree=get(scrollayout0,'ViewPort'); %le vp est la fenetre a gauche

%layout2=BorderLayout; %layout du 
tabpane1=JTabbedPane; 

%******
%ajout des controles sur figure properties panel1 Figure Properties
%******
figprop0=JPanel;
figprop0.setLayout(BorderLayout);

figprop1=JScrollPane; %scroll panel qui va contenir le Jpanel fig properties
scrollayout1=ScrollPaneLayout;  %creation d'un scrollayout
figprop1.setLayout(scrollayout1);
%dim=figprop1.size;


vp_fig_prop=get(scrollayout1,'ViewPort');

figprop=JPanel;
fig_prop_layout=GridLayout(0,1);
figprop.setLayout(fig_prop_layout);
gridx=JRadioButton('gridx');
gridy=JRadioButton('gridy');
label1=JLabel('figure name');
label2=JLabel('X axes name');
label3=JLabel('Y axes name');
text1=JTextField('enter a text');
text2=JTextField('');
text3=JTextField('');
trace=JButton('draw graphic');
set(trace,'Width',500);
figprop.add(label1);
figprop.add(text1);
figprop.add(label2);
figprop.add(text2);
figprop.add(label3);
figprop.add(text3);
figprop.add(gridx);
figprop.add(gridy);
figprop.add(trace);

figprop1.add(figprop); %ajout de Jpanel figure properties au JScrollPane

figprop1.setMinimumSize(Dimension(100,100));


tabpane1.addTab('Create Figure & Properties',figprop1);

vp_fig_prop.setView(figprop);

%******
%ajout des controles sur figure properties panel2 JTextArea
%******

textscrollpane=JScrollPane;
scrollayout3=ScrollPaneLayout;  %creation d'un scrollayout
textscrollpane.setLayout(scrollayout3);

vp_paneltext=get(scrollayout3,'ViewPort');
textArea = JTextArea(50, 20);

vp_paneltext.setView(textArea);
tabpane1.addTab('Text Area',textscrollpane);

%tabpane1.setTabLayoutPolicy(JTabbedPane.SCROLL_TAB_LAYOUT);
%tabpane1.setMnemonicAt(0, KeyEvent.VK_1);

%***********************************************
%Ajout de tous les TabPanel au panel2
%***********************************************
panel2.add(tabpane1,BorderLayout.CENTER);


%************************************************
% creation d'un tableau
%************************************************

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
panel3.add(t);

%construction du RowHeader
dim=Dimension;
dim.width=60;
%colmodel=t.getColumnModel;
rowname=num2cell((1:100)');     %noms qui apparaissent dans le RowHeader
tablerow=MyTable(rowname,{''}); 
set(tablerow,'ColumnCount',1);
colrender=t.getTableHeader.getDefaultRenderer;
set(tablerow.getColumnModel.getColumn(0),'CellRenderer',colrender);
set(tablerow,'enabled','on');
rh=awtcreate('javax.swing.JViewport'); 
set(rh,'PreferredSize',dim);
rh.setView(tablerow)        %viewport pour row header
set(panel3,'Rowheader',rh); %ajoute le viewport

% creation d'unviewport pour afficher le tree
panel.add(tree); %ajout de l'arbre au panel

vp_tree.setView(tree);        %viewport pour row header

% mise en forme general
split = JSplitPane;
split.add(panel,split.LEFT);
split2 = JSplitPane;
set(split2,'Orientation',0);

split2.add(panel2,split2.LEFT);
split2.add(panel3,split2.RIGHT);
split.add(split2,split.RIGHT);

%creation de la figure principale
%recuperation du handle du panel principal
pane_bidon=JPanel;

set(pane_bidon,'Visible','off');
f = figure('toolbar','none','menubar','none');

v=javacomponent(pane_bidon,java.awt.BorderLayout.WEST,f);
drawnow;
u=pane_bidon.getParent;
u.updateUI;
g=u.getComponent(0);


p10=u.getComponent(0);%object in the BorderLayout.WEST
p11=u.getComponent(1);%object in the BorderLayout.CENTER


p12=p11.getComponent(0);
p13=p11.getComponent(1);
p15=p13.getAccessibleContext;

toolbar=JToolBar('Still draggable');
newData=JButton('generate new data');
toolbar.add(newData);
toolbar.addSeparator;
clcData=JButton('clear data');
toolbar.add(clcData);


p12.setLayout(BorderLayout);
p12.add(toolbar,BorderLayout.NORTH);
p12.add(split);
vp_table.setView(t); %applique le tableau au viewPort

u.updateUI;
try
set(p13,'Visible','off');
catch
delete(v);
end


%************************
%Callback du boutton tracer
%************************
%les arguments sont
%1) la fonction callback a appeler
%2) les handles des objets java
%3) les parametres complementaires

set(trace,'MouseClickedCallback',...
 {@Callback_trace, trace, panel3, tree,text1,...
 text2, text3, gridx, gridy, c})

%************************
%Callback du boutton gridx
%************************
%les arguments sont
%1) la fonction callback a appeler
%2) les handles des objets java
%3) les parametres complementaires

set(gridx,'MouseClickedCallback'...
    ,{@Callback_gridx,gridx,text1});

%************************
%Callback du boutton gridy
%************************
%les arguments sont
%1) la fonction callback a appeler
%2) les handles des objets java
%3) les parametres complementaires

set(gridy,'MouseClickedCallback'...
    ,{@Callback_gridy,gridy,text1});

%************************
%Callback du tree control
%************************
%les arguments sont
%1) la fonction callback a appeler
%2) les handles des objets java
%3) les parametres complementaires
set(tree,'ValueChangedCallback'...
    ,{@Callback_tree,tree,text1});

%************************
%Callback du generate data control
%************************
%les arguments sont
%1) la fonction callback a appeler
%2) les handles des objets java
%3) les parametres complementaires

set(newData,'MouseClickedCallback',...
 {@Callback_gen_data,panel3,scrollayout,u});

%************************
%Callback du generate data control
%************************
%les arguments sont
%1) la fonction callback a appeler
%2) les handles des objets java
%3) les parametres complementaires

set(clcData,'MouseClickedCallback',...
 {@Callback_clc_data,panel3});
