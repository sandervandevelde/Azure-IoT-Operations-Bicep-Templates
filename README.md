# Bicep templates for Azure IoT Operations

## Introduction

This repository provides examples of Bicep configuration files used to manage Azure IoT Operations data flows and endpoints.

## Blog post

This repository is featured in [this blog post about sending commands](https://sandervandevelde.wordpress.com/2024/12/09/azure-iot-operations-sending-commands-via-eventgrid-mqtt/) 

## Enable / Disable dataflows

Once a dataflow is added via Bicep, the current user interface does not support it to be added.

To enable/disable these data flows, redeploy The Bicep script with the mode being changed:

Enable:
```
  properties: {
    mode: 'Enabled'
```

Disable:
```
  properties: {
    mode: 'Disabled'
```

## Contributions

If you want to contribute, plaese provide a pull request.
