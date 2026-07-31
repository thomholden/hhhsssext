%Create node using document name
v = XMLNode('plant_catalog.xml')

plants = v('//PLANT')
plants(3).COMMON
res = plants(3).COMMON{'node()'}

allPlantNames = v{'//PLANT/COMMON'}

v.CATALOG.PLANT(7).COMMON
res = v.CATALOG.PLANT(7).COMMON{'node()'}

zone3plantNameNodes = v('//PLANT[ZONE="3"]/COMMON')
zone3plantNames = v{'//PLANT[ZONE="3"]/COMMON'}

plantWithMostAvailability = v{'//PLANT[AVAILABILITY = max(//AVAILABILITY)]/COMMON'}

uniqueBotanicals = v{'//PLANT[not(BOTANICAL = preceding-sibling::*/BOTANICAL)]/BOTANICAL'}

%Newly supported syntax
prices = plants('PRICE')