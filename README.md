### Helm Chart for Spark Operator

This is the Helm chart for the [Kubernetes Operator for Apache Spark](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator).

#### Prerequisites

The Operator requires Kubernetes version 1.8 and above because it relies on garbage collection of custom resources. If customization of driver and executor pods (through mounting custom ConfigMaps and volumes) is desired, then the [Mutating Admission Webhook](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/quick-start-guide.md#using-the-mutating-admission-webhook) needs to be enabled and it only became beta in Kubernetes 1.9.

#### Installing the chart

The chart can be installed by cloning the repo and running:

```bash
$ helm install ./fdp-sparkoperator --namespace spark-operator
```
Also you could use a released artifact from Github releases instead, when invoking `helm install`.

Note that you need to use the `--namespace` flag during `helm install` to specify the namespace into which you want to install the operator. The namespace can be existing or not. When it's not available, Helm will take care of creating the namespace. Note that this namespace has no relation to the namespace where you would like to deploy Spark jobs (i.e. the setting `sparkJobNamespace` shown in the table below). They can be the same namespace or different ones.

#### Configuration

The following table lists the configurable parameters of the Spark operator chart and their default values.

| Parameter           | Description                                                  | Default                              |
| ------------------- | ------------------------------------------------------------ | ------------------------------------ |
| `operatorImageName` | The name of the operator image                               | `lightbend/sparkoperator`            |
| `operatorVersion`   | The version of the operator to install                       | `2.1.2-OpenShift-v1beta2-1.0.1-2.4.4-rh-2.12` |
| `imagePullPolicy`   | Docker image pull policy                                     | `IfNotPresent`                       |
| `sparkJobNamespace` | K8s namespace where Spark jobs are to be deployed. It is also the namespace that the operator instance is to manage. | `default` |
| `enableWebhook`     | Whether to enable mutating admission webhook                 | true                                 |
| `enableMetrics`     | Whether to expose metrics to be scraped by Premetheus        | true                                 |
| `controllerThreads` | Number of worker threads used by the SparkApplication controller | 10                               |
| `ingressUrlFormat`  | Ingress URL format                                           | ""                                   |
| `installCrds`       | Whether to install CRDs                                      | true                                 |
| `logLevel`          | Logging verbosity level                                      | 2                                    |
| `metricsPort`       | Port for the metrics endpoint                                | 10254                                |
| `metricsEndpoint`   | Metrics endpoint                                             | "/metrics"                           |
| `metricsPrefix`     | Prefix for the metrics                                       | ""                                   |
| `nodeSelector`      | Node selector for operator pod assignment                    | {}                                   |
| `rbac.create`       | Whether to create required roles and bindings                | `true`                               |
| `resyncInterval`    | Informer resync interval in seconds                          | 30                                   |
| `webhookPort`       | Service port of the webhook server                           | 8080                                 |
| `resources` | Resources needed for the operator deployment | {} |
| `enableBatchScheduler` | Whether to enable batch scheduler for pod scheduling | false |
| `enableResourceQuotaEnforcement` | Whether to enable the ResourceQuota enforcement for SparkApplication resources. Requires the webhook to be enabled by setting `enableWebhook` to true. | false |
| `enableLeaderElection` | Whether to enable leader election when the operator Deployment has more than one replica, i.e., when `replicas` is greater than 1. | false |
| **Name-related configs** | **See below for further explanation**                   |                                       |
| `nameOverride`      | Suffix for created ServiceAccount names, and value of `app.kubernetes.io/name` labels | <Chart.Name> |
| `fullnameOverride`  | Used when generating fully qualified app name                | ""                                    |
| `serviceAccounts.sparkoperator.create` | Create Spark operator ServiceAccount name using fully qualified app name | `true` |
| `serviceAccounts.sparkoperator.name`   | ServiceAccount name for the Spark operator | `default` if not created             |
| `serviceAccounts.spark.create`         | Create Spark job ServiceAccount name using release name | `true`                  |
| `serviceAccounts.spark.name`           | ServiceAccount name for the Spark jobs     | `default` if not created             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

##### Settings related to naming

The Spark operator namespace is set with the `--namespace` argument to the helm command.

The namespace for the Spark jobs, and the namespace that the Spark operator will watch, is set with the `sparkJobNamespace` config parameter.

All created resources are given `app.kubernetes.io/name` labels with a value the same as the chart name, or the `nameOverride` config parameter if specified.

The `metadata.name` for all created resources uses a computed `fullname` prefix and resource-specific suffix.  The `fullname` will be set from the `fullnameOverride` config value if provided.  Otherwise, if the release name (`--name` Helm argument) contains the `nameOverride` config value, or the chart name, then the `fullname` will be set to the release name value.  Lastly, it will be derived by concatenating the release name with the `nameOverride` value or chart name.  (e.g. With release name `release`, chart name `fdp-sparkoperator`, and neither `overrideName` or `fullnameOverride` having values, the `fullname` will be `release-fdp-sparkoperator` and the `metadata.name` for an initialization Job would be `release-fdp-sparkoperator-init`.)

All created resources are given a `helm.sh/chart` label.  This is derived by concatenating the chart name with the chart version.  For example `fdp-sparkoperator-0.3.0`.

All generated labels and names are truncated to 63 characters to meet Kubernetes constraints.

If the `serviceAccounts.sparkoperator.create` config value is `true`, then the ServiceAccount name for the Spark _operator_ uses the value of the `serviceAccounts.sparkoperator.name` value if provided, or the computed `fullname` as explained above.

If the `serviceAccounts.spark.create` config value is `true`, then the ServiceAccount name for the Spark _job_ uses the value of the `serviceAccounts.spark.name` value if provided, or the concatenation of the release name and the string `-spark` if not.  If the `serviceAccounts.spark.create` config value is instead `false`, then the ServiceAccount name for the Spark _job_ is set to the value of the `serviceAccounts.spark.name` value if provided, or `default` if not.
