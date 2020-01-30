# MEI2PAE

Little XSLT to extract short incipits from MEI files encoded with [Plaine and Easie Code](https://www.iaml.info/plaine-easie-code).

### Usage
The stylesheet takes the first `<score>` element in the file as basis. 
It takes following parameters: 
* `staff` – selects the staff in the MEI file (default is 1)
* `layer` – selects the layer in the MEI file (default is 1)
* `measures` – adjusts the number of measures to be taken into account (default is 4)

#### Known limitations
* only for common music notation (*MEI CMN*)
* measure rests are not combined
* fermatas will be ignored
* tuplets are treated as triplets

## Example implementation
The template aims to be used in other projects. For example you may try the `add-incipit.xsl`, that adds an incipit to the `<work>` element in MEI 3 and MEI 4 files.
