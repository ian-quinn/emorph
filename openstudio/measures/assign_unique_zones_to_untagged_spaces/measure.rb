# *******************************************************************************
# OpenStudio(R), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://openstudio.net/license
# *******************************************************************************

# The script has been updated from OpenStudio 2.X ruleset to 3.X measure
# Track the original one at GitHub
# openstudio-sketchup-plugin/plugin/openstudio/user_scripts/Alter or Add Model Elements/Add_New_Thermal_Zone_For_Spaces_With_No_Thermal_Zone.rb

# Each user script is implemented within a class that derives from OpenStudio::Measure::UserScript
class AssignUniqueZonesToUntaggedSpaces < OpenStudio::Measure::ModelMeasure

  # override name to return the name of your script
  def name
    return "Add New Thermal Zone For Spaces With No Thermal Zone"
  end

  # returns a vector of arguments, the runner will present these arguments to the user
  # then pass in the results on run
  def arguments(model)
    args = OpenStudio::Measure::OSArgumentVector.new
    return args
  end

  # override run to implement the functionality of your script
  # model is an OpenStudio::Model::Model, runner is a OpenStudio::Measure::UserScriptRunner
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments) # initializes runner for new script

    # get all spaces
    spaces = model.getSpaces

    # loop through spaces
    spaces.each do |space| # this is going through all, not just selection
      if space.thermalZone.empty?
        newthermalzone = OpenStudio::Model::ThermalZone.new(model)
        space.setThermalZone(newthermalzone)
        runner.registerInfo("Created " + newthermalzone.briefDescription + " and assigned " + space.briefDescription + " to it.")
      end
    end

    return true

  end

end

# this call registers your script with the OpenStudio SketchUp plug-in
AssignUniqueZonesToUntaggedSpaces.new.registerWithApplication
