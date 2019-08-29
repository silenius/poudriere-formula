include:
  - poudriere.install
  - poudriere.config

{% set poudriere = salt.pillar.get('poudriere') %}

{% for port in poudriere.ports %}
poudriere_port_{{ port.label }}:
  cmd.run:
    - name: poudriere ports -c -p {{ port.label }} -m {{ port.method }}
    {%- if port.branch is defined %} -B "{{ port.branch }}" {%- endif %}
    - shell: /bin/sh
    - unless: poudriere ports -lnq | grep -E '^{{ port.label }}' 
    - require:
      - file: poudriere_conf
{% endfor %}
