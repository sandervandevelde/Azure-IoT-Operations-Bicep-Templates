param aioInstanceName string = 'uno148v2advantechcluster-ops-instance'
param customLocationName string = 'uno148v2advantechcln'
param dataflowName string = 'azure-eventgrid-mqtt-2-local-mqtt'

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

// Pointer to the eventgrid mqtt broker dataflow endpoint
resource eventgridMqttDataflowEndpoint 'Microsoft.IoTOperations/instances/dataflowEndpoints@2024-11-01' existing = {
  parent: aioInstance
  name: 'azure-eventgrid-mqtt-endpoint'
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
          // Use the EventGrid MQTT endpoint as the source
          endpointRef: eventgridMqttDataflowEndpoint.name
          // Filter the data from the EventGrid MQTT topic 
          dataSources: [
            'sendtopic/aio/fromcloud/cloud'
          ]
        }
      }
      {
        operationType: 'Destination'
        destinationSettings: {
          // Use the default MQTT endpoint as the destination
          endpointRef: defaultDataflowEndpoint.name
          // Send the data to the default MQTT topic 
          dataDestination: 'target/data/local'
        }
      }
    ]
  }
}
