# Autocomletion a validace pro manifesty openshiftu spolu s CRD

## TOOLING

```bash
# tooling instalace
python3 -m venv ~/venv/openapi
source ~/venv/openapi/bin/activate                                │

pip install "cython<3.0.0" && pip install --no-build-isolation pyyaml==5.4.1
pip install --upgrade setuptools wheel
pip install openapi2jsonschema

```

```bash
#get openapi spec, ale nebudeme ji potrebovat
oc get --raw /openapi/v2 > openapi-v2.json
#nebo

oc proxy --port=8080 &
curl -k -X GET -H 'Accept: application/json' http://127.0.0.1:8080/openapi/v2 --output scheme2.json
```

```bash
#tooling nad openapi2jsonschema ktery vyhaze nevalidni openapiscpec
git clone git@github.com:sabre1041/k8s-manifest-validation.git
cd k8s-manifest-validation
# dela v tom trochu bordel trident kdy nektere apidef jsou validni a jine ne, takze je vyhazu vsechny
vim scripts/build_schema.py
#replace delete_list=[], asi by to slo udelat i hezceji nejakym regex matchem ale pro test dobry
delete_list = ['io.netapp.trident.v1.TridentActionMirrorUpdate', 'io.netapp.trident.v1.TridentActionSnapshotRestore', 'io.netapp.trident.v1.TridentBackendConfig', 'io.netapp.trident.v1.TridentBackend', 'io.netapp.trident.v1.TridentConfigurator', 'io.netapp.trident.v1.TridentMirrorRelationship', 'io.netapp.trident.v1.TridentNode', 'io.netapp.trident.v1.TridentOrchestrator', 'io.netapp.trident.v1.TridentSnapshotInfo', 'io.netapp.trident.v1.TridentSnapshot', 'io.netapp.trident.v1.TridentStorageClass', 'io.netapp.trident.v1.TridentTransaction', 'io.netapp.trident.v1.TridentVersion', 'io.netapp.trident.v1.TridentVolumePublication', 'io.netapp.trident.v1.TridentVolumeReference', 'io.netapp.trident.v1.TridentVolume', 'io.netapp.trident.v1.TridentActionMirrorUpdateList', 'io.netapp.trident.v1.TridentActionSnapshotRestoreList', 'io.netapp.trident.v1.TridentBackendConfigList', 'io.netapp.trident.v1.TridentBackendList', 'io.netapp.trident.v1.TridentConfiguratorList', 'io.netapp.trident.v1.TridentMirrorRelationshipList', 'io.netapp.trident.v1.TridentNodeList', 'io.netapp.trident.v1.TridentOrchestratorList', 'io.netapp.trident.v1.TridentSnapshotInfoList', 'io.netapp.trident.v1.TridentSnapshotList', 'io.netapp.trident.v1.TridentStorageClassList', 'io.netapp.trident.v1.TridentTransactionList', 'io.netapp.trident.v1.TridentVersionList', 'io.netapp.trident.v1.TridentVolumeList', 'io.netapp.trident.v1.TridentVolumePublicationList', 'io.netapp.trident.v1.TridentVolumeReferenceList']
#change
if "properties" not in type_def and type_name not in delete_list:

oc proxy --port=8080 &
python build_schema.py -u http://127.0.0.1:8080 -t "" -d output_directory
# jsonspec mame v adresari openshift-json-schema
```
