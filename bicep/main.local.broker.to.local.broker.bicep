param aioInstanceName string = 'uno148v2advantechcluster-ops-instance'
param customLocationName string = 'uno148v2advantechcln'
param dataflowName string = 'testdataflownamemd'

resource aioInstance 'Microsoft.IoTOperations/instances@2024-11-01' existing = {
  name: aioInstanceName
}

resource customLocation 'Microsoft.ExtendedLocation/customLocations@2021-08-31-preview' existing = {
  name: customLocationName
}

// Pointer to the default dataflow endpoint
resource defaultDataflowEndpoint 'Microsoft.IoTOperations/instances/dataflowEndpoints@2024-11-01' existing = {
  parent: aioInstance
  name: 'default'
}

// Pointer to the default dataflow profile
resource defaultDataflowProfile 'Microsoft.IoTOperations/instances/dataflowProfiles@2024-11-01' existing = {
  parent: aioInstance
  name: 'default'
}

resource dataflow 'Microsoft.IoTOperations/instances/dataflowProfiles/dataflows@2024-11-01' = {
  // Reference to the parent dataflow profile, the default profile in this case
  // Same usage as profileRef in Kubernetes YAML
  parent: defaultDataflowProfile
  name: dataflowName
  extendedLocation: {
    name: customLocation.id
    type: 'CustomLocation'
  }
  properties: {
    mode: 'Enabled'
    operations: [
      {
        operationType: 'Source'
        sourceSettings: {
          // Use the default MQTT endpoint as the source
          endpointRef: defaultDataflowEndpoint.name
          // Filter the data from the MQTT topic azure-iot-operations/data/thermostat
          dataSources: [
            'source/data/thermostat'
          ]
        }
      }
      {
        operationType: 'Destination'
        destinationSettings: {
          // Use the default MQTT endpoint as the destination
          endpointRef: defaultDataflowEndpoint.name
          // Send the data to the MQTT topic factory/data/thermostat
          dataDestination: 'target/data/thermostat'
        }
      }
    ]
  }
}
