// LookupFieldCellEditor - Modified DefaultCellEditor for lookup fields drop-down cells

// Programmed by Yair M. Altman: altmany(at)gmail.com
// $Revision: 1.1 $  $Date: 2006/11/14 14:32:19 $

import java.awt.*;
import java.util.*;
import javax.swing.*;

public class LookupFieldCellEditor extends DefaultCellEditor
{
	private boolean _debug = false;
	private int _lookupColumn = -1;
	private Hashtable _dataFields = null;

	public LookupFieldCellEditor()
	{
		super(new JComboBox());
	}

	public LookupFieldCellEditor(Hashtable dataFields)
	{
		super(new JComboBox());
		_dataFields = dataFields;
	}

	public LookupFieldCellEditor(Hashtable dataFields, int lookupColumn)
	{
		super(new JComboBox());
		_dataFields = dataFields;
		_lookupColumn = lookupColumn;
	}

	public Component getTableCellEditorComponent(JTable table, Object value, boolean isSelected, int row, int column)
	{
		JComboBox cell = (JComboBox) super.getTableCellEditorComponent(table, value, isSelected, row, column);
		if (_debug) System.out.println(row + "," + column + " => current value: " + value);

		// Modify the selected row's CellEditors (JComboBox) to display only relevant fields
		if (_lookupColumn >= 0)
		{
			cell.removeAllItems();
			Object lookupObj = table.getValueAt(row,_lookupColumn);
			if (_debug) System.out.println(row + "," + column + " => source: " + lookupObj);
			if (lookupObj != null)
			{
				String srcName = (String) lookupObj;
				if (_dataFields.containsKey(srcName))
				{
					String[] dataVals = (String[]) _dataFields.get(srcName);
					java.util.List<String> dataList = Arrays.asList(dataVals);
					if (_debug) System.out.println(row + "," + column + " => " + srcName + " data: " + dataList);
					java.util.Iterator iter = dataList.iterator();
					while (iter.hasNext())
					{
						cell.addItem(iter.next());
					}
				}
			}
			if (_debug) System.out.println(row + "," + column + " => count: " + cell.getItemCount());
		}

		cell.setSelectedItem(value);
		cell.setMaximumRowCount(cell.getItemCount()==0 ? 1 : 10);
		if (cell.getItemCount() == 0)
		{
			cell.hidePopup();	// doesn't work... argh!!!
			cell.addItem("");
		}

		return cell;
	}

	public void setDebug(boolean flag)
	{
		_debug = flag;
	}

	public boolean isDebug()
	{
		return _debug;
	}

	public void setLookupColumn(int column)
	{
		_lookupColumn = column;
	}

	public int getLookupColumn()
	{
		return _lookupColumn;
	}

	public void setEditable(boolean flag)
	{
		((JComboBox) getComponent()).setEditable(flag);
	}

	public boolean isEditable()
	{
		return ((JComboBox) getComponent()).isEditable();
	}

	public Hashtable getLookupData()
	{
		return _dataFields;
	}

	public void setLookupData(Hashtable dataFields)
	{
		_dataFields = dataFields;
	}
}
