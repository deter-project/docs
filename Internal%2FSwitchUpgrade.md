# ISI

Existing Switches and their replacements.

## Cisco4
### Current Configuration
* 7x 48 port modules

### Proposed Configuration
* 2x 5412zl chassis
* 2x quad cx4 modules
* 14x gigabit ethernet modules

## Nortel10
### Current Configuration
* 6x 5510-48T
* 1x 5530-24TFD

### Proposed Configuration
* 2x 5412zl chassis
* 2x quad cx4 module
* 13x 24 port gigabit ethernet modules (7 in one chassis, 6 for the other)

## Nortel18e
### Current Configuration
* 7x 5510-48T
* 1x 5530-24TFD

### Proposed Configuration
* 2x 5412zl chassis.
* 2x quad cx4 modules
* 15x 24 port gigabit ethernet modules (8 for one chassis, 6 for the other). 

# New star switch

one cx4 card per experimental switch. 

* 1x 5400zl chassis
* 6x cx4 cards
* 1x x2 card for dragon

# Totals

* 7x 5400zl chassis
* 12x cx4 modules
* 42x 24 port gigabit
* 1x X2 module

# Parts from HP

## Descriptions and Links

* [J8700A](http://h10010.www1.hp.com/wwpc/us/en/sm/WF06b/12883-12883-4172267-4172305-4172283-1827663-1827669-1827685.html?jumpid=oc_R1002_USENC-001_HP%20E5412-96G%20zl%20Switch&lang=en&cc=us) HP E5412-96G zl Switch (includes: 2 x J8712AHP 875 W zl Power Supply)
* [J8702A](http://h10010.www1.hp.com/wwpc/us/en/sm/WF06c/A10-51210-64274-4179423-64274-4202309-1839923-1839926.html?jumpid=oc_R1002_USENC-001_HP%2024-port%2010/100/1000%20PoE%20zl%20Module&lang=en&cc=us) HP 24-port 10/100/1000 PoE zl Module
* [J8705A](http://h10010.www1.hp.com/wwpc/us/en/sm/WF06c/A10-51210-64274-4179423-64274-4202309-1839930-1839932.html?jumpid=oc_R1002_USENC-001_HP%2020-port%20Gig-T%20/%204-port%20Mini-GBIC%20zl%20Module&lang=en&cc=us) HP 20-port Gig-T / 4-port Mini-GBIC zl Module
* [J8707A](http://h10010.www1.hp.com/wwpc/us/en/sm/WF06c/A10-51210-64274-4179423-64274-4295060-1839918-1839920.html?jumpid=oc_R1002_USENC-001_HP%204-port%2010GbE%20X2%20zl%20Module&lang=en&cc=us) HP 4-port 10GbE X2 zl Module
* [J8708A](http://h10010.www1.hp.com/wwpc/us/en/sm/WF06c/A10-51210-64274-4179423-64274-1839933-4287694-1839936.html?jumpid=oc_R1002_USENC-001_HP%204-port%2010GbE%20CX4%20zl%20Module&lang=en&cc=us) HP 4-port 10GbE CX4 zl Module
* [J8437A](http://h10010.www1.hp.com/wwpc/us/en/sm/WF06c/A10-51210-64274-64484-64274-4293022-450139-450137.html?jumpid=oc_R1002_USENC-001_HP%2010GbE%20X2-SC%20LR%20Optic&lang=en&cc=us) HP 10GbE X2-SC LR Optic
* [J8436A](http://h20000.www2.hp.com/bizsupport/TechSupport/Home.jsp?lang=en&cc=us&prodTypeId=329290&prodSeriesId=4293022&lang=en&cc=us) HP 10GbE X2-SC SR Optic (EOL?
* [J9309A](http://h17007.www1.hp.com/us/en/products/switches/HP_E5400_zl_Switch_Series/index.aspx#J9309A) HP quad 10GbE SFP+ zl Module (click on accessories; only available as popup page)
* [J9151A](http://h17007.www1.hp.com/us/en/products/switches/HP_E5400_zl_Switch_Series/index.aspx#J9151A) HP 10GbE SFP+ LC LR Transceiver

## Parts count

* 7x  J8700A HP E5412-96G zl Switch
* 14x J8702A HP 24-port 10/100/1000 PoE zl Module (42 - 28 that come with the 5412zl-96g)
* 12x J8708A HP 4-port 10GbE CX4 zl Module
* 1x  J8707A HP 4-port 10GbE X2 zl Module
* 1x  J8437A HP 10GbE X2-SC LR Optic

# Berkeley

Existing Switches and their replacements.

## Bnortele4, Bnortelc4
### Current Configuration
* 4x 48 port modules (Bnortele4)
* 1x J8699 HP ProCurve Switch 5406zl-48G Intelligent Edge - switch - 48 ports

### Proposed Configuration - Bhpvx
* 1x 5412zl chassis
* 2x quad cx4 modules
* 8x gigabit ethernet modules

## Bnortele, Bnortelc, Bnortelc2 
### Current Configuration
* 6x 5510-48T
* 1x 5530-24TFD
* 2x J8699 HP ProCurve Switch 5406zl-48G Intelligent Edge - switch - 48 ports

### Proposed Configuration - Bhpod 
* 1x 5412zl chassis
* 2x quad cx4 module
* 8x 24 port gigabit ethernet modules

### Proposed Configuration - Bhpmd 
* 1x 5412zl chassis
* 2x quad cx4 module
* 8x 24 port gigabit ethernet modules

## Bnortele3, Bnortelc3 
### Current Configuration
* 4x 5510-48T

### Proposed Configuration - Bhp5 
* 1x 5412zl chassis
* 1x quad 10GbE SFP module (J9309A)
* 8x 24 port gigabit ethernet modules
* 1x 10GbE SFP+ LC LR Transceiver (J9151A)

## Bhp1
### Current Configuration 
* 1x 5412zl chassis
* 6x 24 port gigabit ethernet modules
* 1x 20 port gbe + 4 gbic module
* 1x quad cx4 module
* 1x quad x2 module
* 1x X2 LR optical interface

### Proposed Configuration 
* 1x 5412zl chassis
* 6x 24 port gigabit ethernet modules
* 1x 20 port gbe + 4 gbic module
* 2x quad cx4 module

## Bhp3
### Current Configuration 
* 1x 5412zl chassis
* 8x 24 port gigabit ethernet modules
* 1x 20 port gbe + 4 gbic module
* 1x quad cx4 module
* 1x quad x2 module
* 1x X2 LR optical interface

### Proposed Configuration 
* 1x 5412zl chassis
* 8x 24 port gigabit ethernet modules
* 1x 20 port gbe + 4 gbic module
* 2x quad cx4 module
* 1x quad x2 module
* 2x X2 LR optical interface

## Bhp4
### Current Configuration 
* 1x 5412zl chassis
* 8x 24 port gigabit ethernet modules
* 1x quad cx4 module
* 1x quad x2 module
* 1x X2 LR optical interface
* 1x X2 SR optical interface

### Proposed Configuration 
* 1x 5412zl chassis
* 8x 24 port gigabit ethernet modules
* 2x quad cx4 module
* 1x quad x2 module
* 1x X2 SR optical interface

# New star switch Bhpst
* (Two cx4 cards per experimental switch in soda)
* (One optical module + 2 optical interfaces to talk to black box, 1 to Bhphp)

### Proposed Configuration 
* 1x 5412zl chassis
* 8x quad cx4 module
* 1x quad x2 module
* 3x X2 LR optical interface

# Totals and difference from parts on hand
## Totals
* 8x 5412zl chassis
* 6x power supplies
* 54x 24 port gigabit ethernet modules
* 2x 20 port gbe + 4 gbic module
* 20x quad cx4 module
* 3x quad X2 module
* 4x X2 LR optical interface
* 1x X2 SR optical interface
* 1x quad SFP+ module

## Parts count for differences
* 6x  J8700A HP E5412-96G zl Switch
* 1x  J8713A HP 1.5kw power supply (lanstreet for $529)
* 2x  J8702A HP 24-port 10/100/1000 PoE zl Module (18-16 that come with the 5412zl-96g)
* 1x  J9309A HP 4-port 10GbE SFP+ zl Module
* 17x J8708A HP 4-port 10GbE CX4 zl Module
* 2x  J8437A HP 10GbE X2-SC LR Transceiver
* 1x  J9141A HP 10GbE SFP+ LC LR Transceiver
