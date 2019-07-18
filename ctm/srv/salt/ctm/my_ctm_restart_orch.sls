# salt/mwmodern/adp_restart_orch.sls

# Orchestration file to execute Pre-tasks, Wait for patch reboot and Post-tasks

# Run via: salt-run state.orchestrate mwmodern.adp_restart_orch pillar='{nodes: [nodeA, nodeB]}'

# Note: This orchestration file is applicable only for Adapter Servers

 

{% set hosts = salt.pillar.get('nodes', [])|join(',') %}

{% for host in hosts %}


STOP_CTMAPPS:
  salt.state:
    - tgt: {{ host }}
    - sls:
      - ctm.stop_ctmapps


# Assuming OS patch would happen here
#####################################
REBOOT_{{ host }}:
  salt.function:
#    - name: system.reboot
    - name: disk.blkid
    - tgt: {{ host }}
####################################


WAIT_FOR_REBOOT:
  salt.wait_for_event:
    - salt/minion/*/start
    - timeout: 1800
    - id_list:
      - {{ host }}
    - require:
      - salt: REBOOT_{{ host }}

START_CTMAPPS:
  salt.state:
    - tgt: {{ host }}
    - sls:
      - ctm.start_ctmapps
    - require:
      - salt: WAIT_FOR_REBOOT

{% endfor %}
