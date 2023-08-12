# Bash Reminder


## Fonctions

- **add** : Add value to the reminder with the wanted message and importance, if importance is not specified it will use the default value visible in the file
- **list** : List all the remiders or just the one from the specified importance
- **del** : Delete the remider with the specified uuid
- **prune** : Delete all the checked remiders from any or the specified importance
- **modify** : Modify the remider with the specified uuid using those options : -m <message> and -i <importance>
- **check** : Check the remider with the specified uuid
- **link** : Change the file to the one specified (NOT RECOMMENDED)
- **config** : Change the value of some of the main tags like : show to change the visibilty of list or the default value
- **echo** "init : Initialize a good storage file"
- **help** : Show the helper

## Data Storage Architecture

All the data are store in a yaml file.
The default name is `.sh-rem-data.yaml`

```yaml
show: true
default: 3
importance_number: 5
I1:
    - uuid:
        - "Text"
        - checked: false
I2:
    ...
I3:
    ...
I4:
    ...
I5:
    ...
```

the tags : **show**, **default** and **importance_number** are updatable using the modify parameter.

- **show** : true will print the reminder, false will not print it. (-> used for .bashrc automatisation)
- **default** : the importance number that will be use by default.
- **importance_number** : the importance max that will be print out by the list function.

## Prerequisite

- yq, a yaml bash control tool

for installing yq (on ubuntu 22.04) :
```
- sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
- sudo chmod a+x /usr/local/bin/yq
- yq --version
``````
for removing yq from your system :
```
- sudo rm -rf /usr/local/bin/yq
```