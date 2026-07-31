/* 
 Originally downloaded from http://www.javaworld.com/javaworld/jw-05-2001/jw-0525-mdi.html#resources
 */

package com.mathworks.demos.finance.portoptdemo;
import javax.swing.*;
import javax.swing.event.*;
import java.awt.event.*;
import java.beans.*;
import java.util.ResourceBundle;

/**
 * Menu component that handles the functionality expected of a standard
 * "Windows" menu for MDI applications.
 */
public class WindowMenu extends JMenu implements CustomJComponent {
    private MDIDesktopPane fDesktop;
    private JMenuItem fCascadeMenuItem=new JMenuItem("Cascade");
    private JMenuItem fTileMenuItem=new JMenuItem("Tile");
    private JMenuItem fDefaultLayoutMenuItem=new JMenuItem("Default Layout");

    public WindowMenu(MDIDesktopPane desktop) {
        this.fDesktop=desktop;
        setText("Window");
        fCascadeMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ae) {
                WindowMenu.this.fDesktop.cascadeFrames();
            }
        });
        fTileMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ae) {
                WindowMenu.this.fDesktop.tileFrames();
            }
        });
        fDefaultLayoutMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ae) {
                WindowMenu.this.fDesktop.defaultLayout();
            }
        });
        addMenuListener(new MenuListener() {
            public void menuCanceled (MenuEvent e) {}

            public void menuDeselected (MenuEvent e) {
                removeAll();
            }

            public void menuSelected (MenuEvent e) {
                buildChildMenus();
            }
        });
    }

    /* Sets up the children menus depending on the current desktop state */
    private void buildChildMenus() {
        int i;
        ChildMenuItem menu;
        JInternalFrame[] array = fDesktop.getAllFrames();

        add(fCascadeMenuItem);
        add(fTileMenuItem);
        add(fDefaultLayoutMenuItem);
        
        if (array.length > 0) addSeparator();
        fCascadeMenuItem.setEnabled(array.length > 0);
        fTileMenuItem.setEnabled(array.length > 0);
        fDefaultLayoutMenuItem.setEnabled(array.length > 0);

        for (i = 0; i < array.length; i++) {
            if(array[i].isVisible())
            {
                menu = new ChildMenuItem(array[i]);
                menu.addActionListener(new ActionListener() {
                    public void actionPerformed(ActionEvent ae) {
                        JInternalFrame frame = ((ChildMenuItem)ae.getSource()).getFrame();
                        frame.moveToFront();
                        try {
                            frame.setSelected(true);
                        } catch (PropertyVetoException e) {
                            e.printStackTrace();
                        }
                    }
                });
                menu.setIcon(array[i].getFrameIcon());
                add(menu);
            }
        }
    }
    
    public void setFontSize(int size)
    {
    }
    
    public void updateForLocale(ResourceBundle localSettings)
    {
        setText(localSettings.getString("WindowMenuText"));
    }


    /* This JCheckBoxMenuItem descendant is used to track the child frame that corresponds
       to a give menu. */
    class ChildMenuItem extends JCheckBoxMenuItem {
        private JInternalFrame frame;

        public ChildMenuItem(JInternalFrame frame) {
            super(frame.getTitle());
            this.frame=frame;
        }

        public JInternalFrame getFrame() {
            return frame;
        }
    }
}