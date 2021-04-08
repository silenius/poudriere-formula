include:
  - poudriere.install
  - poudriere.config

{% set poudriere = salt.pillar.get('poudriere') %}

{% for port in poudriere.ports %}
poudriere_port_{{ port.label }}:
  cmd.run:
{% if port.absent|default(False, boolean=True) %}
    - name: poudriere ports -d -p {{ port.label }}
    - onlyif: poudriere ports -lnq | grep -qE '^{{ port.label }}' 
{% else %}
    {% if (port.method.startswith('svn') or port.method == 'git') %}
    - name: poudriere ports -c -p {{ port.label }} -m {{ port.method }} -B {{ port.branch|default('head/master') }}
    {% else %}
    - name: poudriere ports -c -p {{ port.label }} -m {{ port.method }}
    {% endif %}
    - unless: poudriere ports -lnq | grep -qE '^{{ port.label }}' 
{% endif %}
    - shell: /bin/sh
    - require:
      - file: poudriere_conf
{% endfor %}
