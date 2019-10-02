include
  - poudriere.install
  - poudriere.config
  - poudriere.ports

{% set poudriere = salt.pillar.get('poudriere') %}

{% for port in poudriere.ports %}
{% if not port.absent|default(False, boolean=True) %}
poudriere_update_port_{{ port.label }}:
  cmd.run:
    - name: poudriere ports -u -p {{ port.label }}
    - onlyif: poudriere ports -lnq | grep -E '^{{ port.label }}' 
    - shell: /bin/sh
    - require:
      - file: poudriere_conf
      - cmd: poudriere_port_{{ port.label }}
{% endif %}
{% endfor %}
