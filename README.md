# emorph :hut:

![OpenStudio](https://img.shields.io/badge/OpenStudio-3.X-blue.svg)
[![wakatime](https://wakatime.com/badge/user/b04d35f7-79c6-4b67-9dd8-73bd60f22c2f/project/018ed0cc-28e6-4731-967d-8da1073cfd44.svg)](https://wakatime.com/badge/user/b04d35f7-79c6-4b67-9dd8-73bd60f22c2f/project/018ed0cc-28e6-4731-967d-8da1073cfd44)

```
emorph
├ *.py				- scripts demo
├ /cases	      
└ /openstudio
  ├ /gbxmls			- gbXML resource
  ├ /seeds			- blank/template .osm
  ├ /weather        - weather resource
  ├ /measures		- openstudio measures
  │ └ /*        
  │   ├ measure.rb
  │   └ measure.xml       
  └ /workflow
    ├ /run			- Utility functions
    └ *.osw			- openstudio workflows
```

## Prototype workflow

This openstudio workflow will create a prototype building with perimeter-core zoning, set its space type and construction by ASHRAE default, run ideal loads system and get the time series of cooling load in .csv output. Make sure you have 3.X version **OpenStudio SDK** installed

```
# replace the installation path in run_osw.py
# which is 'C:\openstudio-3.X.0\bin\openstudio.exe' by default
> py run_osw.py
# the script writes a .osw file under ./openstudio/workflow/
# then execute it by calling openstudio
```
or test the workflow by command line
```
openstudio.exe run -w prototype.osw
```
The best practice to standardize your workflow may be:
- Serialize your typical configurations in the template .osm file, the Schedule:Compact, SimulationControl, Output:Variables...
- Create a standard .osw template with placeholders so that you can render it by user inputs, with engines like Jinja2

## Reference

[MGVisschers](https://github.com/MGVisschers) / [IFC-to-gbXML-converter](https://github.com/MGVisschers/IFC-to-gbXML-converter)
[Building Component Library](https://bcl.nrel.gov/results/?show_rows=25&page=1&fq=measure_tags:Whole%20Building.Space%20Types)