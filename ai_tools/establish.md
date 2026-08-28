# Add Prometheus Data Source to grafana
- open Grafana: `http://192.168.3.52:7002`
Login to Grafana
Go to Connections → Data Sources
Click Add data source
Select Prometheus
Set URL: http://192.168.3.52:7001
Click Save & Test

Prometheus: `http://192.168.3.52:7001`

- to check the values hit `http://192.168.3.52:7001/api/v1/label/__name__/values`


