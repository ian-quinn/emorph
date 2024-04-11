import os, json, subprocess

class jsObject:
    def toJSON(self):
        return json.dumps(
        	self,
            default=lambda o: o.__dict__, 
            sort_keys=True,
            indent=2)

osw = jsObject()
osw.seed_file = "blank.osm"
osw.weather_file = "USA_CO_Denver.Intl.AP.725650_TMY3.epw"
osw.measure_paths = ["../measures/"]
osw.file_paths = ["../weather", "../seeds", "../gbxmls"]
osw.run_directory = "./run"
osw.steps = []

osw.steps.append(jsObject())
step1 = osw.steps[-1]
step1.measure_dir_name = "set_rectangular_floor_plan"
step1.name = "SetRectangularFloorPlan"
step1.arguments = jsObject()
# expose these variables to users
step1.arguments.length = 40.0
step1.arguments.width = 20.0
step1.arguments.num_floors = 3.0
step1.arguments.floor_to_floor_height = 3.8
step1.arguments.plenum_height = 1.0
step1.arguments.perimeter_zone_depth = 4.57

# serialize the following steps if they remain unchanged
# the best practice may be a formatted string
osw.steps.append(jsObject())
step2 = osw.steps[-1]
step2.measure_dir_name = "space_type_and_construction_set_wizard"
step2.name = "SpaceTypeAndConstructionSetWizard"

osw.steps.append(jsObject())
step3 = osw.steps[-1]
step3.measure_dir_name = "assign_unique_zones_to_untagged_spaces"
step3.name = "AssignUniqueZonesToUntaggedSpaces"

osw.steps.append(jsObject())
step4 = osw.steps[-1]
step4.measure_dir_name = "assign_ideal_loads_system"
step4.name = "AssignIdealLoadsSystem"

osw.steps.append(jsObject())
step5 = osw.steps[-1]
step5.measure_dir_name = "set_simulation_control"
step5.name = "SetSimulationControl"

osw.steps.append(jsObject())
step6 = osw.steps[-1]
step6.measure_dir_name = "add_output_variable"
step6.name = "AddOutputVariable"
step6.arguments = jsObject()
step6.arguments.variable_name = "Zone Ideal Loads Supply Air Total Cooling Energy"

osw.steps.append(jsObject())
step7 = osw.steps[-1]
step7.measure_dir_name = "create_csv_output"
step7.name = "CreateCSVOutput"

with open('./openstudio/workflow/_.osw', 'w') as file:
    file.write(osw.toJSON())

# -----------------------------------------------------------

os_path = "C:\\openstudio\\bin\\openstudio.exe"
osw_path = os.path.abspath("./openstudio/workflow/_.osw")
command = os_path + " run -w " + osw_path
print(command)
result = subprocess.run(command, capture_output=True)
print(result.stdout)