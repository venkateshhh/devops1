{% import_yaml "ctm/ctm_os_patching_vars.yml" as mw_data %}

ctm_home_mounted:
  module.run:
    - name: mount.is_mounted
    - m_name: /usr/ctmdomain/WLS


stop_ctmapps:
  cmd.run:
    - name: 
        /etc/rc3.d/S94ctms stop
        /etc/rc3.d/S95ctm stop
        /etc/rc3.d/S96ctmem stop
- require:
      - CTM_home_mounted


