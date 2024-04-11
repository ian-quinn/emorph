# *******************************************************************************
# OpenStudio(R), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://openstudio.net/license
# *******************************************************************************

# revised based on the BCL version
# openstudio-common-measures-gem/lib/measures/EnableIdealAirLoadsForAllZones/measure.rb

# reference scripts
# OpenStudio-resources/model/simulationtests/ideal_loads_w_plenums.rb

# start the measure
class AssignIdealLoadsSystem < OpenStudio::Measure::ModelMeasure
  # define the name that a user will see, this method may be deprecated as
  # the display name in PAT comes from the name field in measure.xml
  def name
    return 'AssignIdealLoadsSystem'
  end

  # define the arguments that the user will input
  def arguments(model)
    args = OpenStudio::Measure::OSArgumentVector.new
    cooling_setpoint = OpenStudio::Measure::OSArgument::makeDoubleArgument("cooling_setpoint",false)
    cooling_setpoint.setDisplayName("Cooling Setpoint")
    cooling_setpoint.setDefaultValue(27.0)
    args << cooling_setpoint

    heating_setpoint = OpenStudio::Measure::OSArgument::makeDoubleArgument("heating_setpoint",false)
    heating_setpoint.setDisplayName("Heating Setpoint")
    heating_setpoint.setDefaultValue(16.0)
    args << heating_setpoint
    return args
  end

  # define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    cooling_set = runner.getDoubleArgumentValue("cooling_setpoint",user_arguments)
    heating_set = runner.getDoubleArgumentValue("heating_setpoint",user_arguments)

    # array of zones initially using ideal air loads
    # startingIdealAir = []

    # remove zone equipment except for exhaust and natural ventilation
    # zone_hvac_ideal_found = false
    # model.getZoneHVACComponents.each do |component|
    #   next if component.to_FanZoneExhaust.is_initialized
    #   component.remove
    # end

    thermalZones = model.getThermalZones
    thermalZones.each do |zone|
      ideal_loads = OpenStudio::Model::ZoneHVACIdealLoadsAirSystem.new(model)
      ideal_loads.addToThermalZone(zone)
    end
    
    # thermalZones.each do |zone|
    #   # TODO: - need to also look for ZoneHVACIdealLoadsAirSystem
    #   if zone.useIdealAirLoads
    #     startingIdealAir << zone
    #   else
    #     if zone_hvac_ideal_found == true
    #       startingIdealAir << zone
    #     else
    #       next if !zone.thermostatSetpointDualSetpoint.is_initialized
    #       ideal_loads = OpenStudio::Model::ZoneHVACIdealLoadsAirSystem.new(model)
    #       ideal_loads.addToThermalZone(zone)
    #       # Set the ideal loads properties
    #       # ideal_loads.setMinimumCoolingTemperature(0.0)
    #       # ideal_loads.setMaximumHeatingSupplyAirTemperature(50.0)
    #       # ideal_loads.setMaximumCoolingSupplyAirTemperature(13.0)
    #     end
    #   end
    # end

    time_24hrs = OpenStudio::Time.new(0, 24, 0, 0)
    cooling_sch = OpenStudio::Model::ScheduleRuleset.new(model)
    cooling_sch.setName("Cooling Sch")
    cooling_sch.defaultDaySchedule.setName("Cooling Sch Default")
    cooling_sch.defaultDaySchedule.addValue(time_24hrs, cooling_set)

    heating_sch = OpenStudio::Model::ScheduleRuleset.new(model)
    heating_sch.setName("Heating Sch")
    heating_sch.defaultDaySchedule.setName("Heating Sch Default")
    heating_sch.defaultDaySchedule.addValue(time_24hrs, heating_set)

    thermalZones.each do |zone|
      new_thermostat = OpenStudio::Model::ThermostatSetpointDualSetpoint.new(model)
      new_thermostat.setHeatingSchedule(heating_sch)
      new_thermostat.setCoolingSchedule(cooling_sch)
      zone.setThermostatSetpointDualSetpoint(new_thermostat)
    end

    # remove air and plant loops not used for SWH
    # model.getAirLoopHVACs.each(&:remove)

    # see if plant loop is swh or not and take proper action (booter loop doesn't have water use equipment)
    # model.getPlantLoops.each do |plant_loop|
    #   is_swh_loop = false
    #   plant_loop.supplyComponents.each do |component|
    #     if component.to_WaterHeaterMixed.is_initialized
    #       is_swh_loop = true
    #       next
    #     end
    #   end
    #   if is_swh_loop == false
    #     plant_loop.remove
    #   end
    # end

    # reporting initial condition of model
    # runner.registerInitialCondition("In the initial model #{startingIdealAir.size} zones use ideal air loads.")

    # # reporting final condition of model
    # finalIdealAir = []
    # thermalZones.each do |zone|
    #   if zone.useIdealAirLoads
    #     finalIdealAir << zone
    #   end
    # end
    # runner.registerFinalCondition("In the final model #{finalIdealAir.size} zones use ideal air loads.")

    return true
  end
end

# this allows the measure to be use by the application
AssignIdealLoadsSystem.new.registerWithApplication
