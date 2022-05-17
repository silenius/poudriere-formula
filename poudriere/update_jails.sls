include:
  - poudriere.install
  - poudriere.config

{% set poudriere = salt.pillar.get('poudriere') %}

{% for jail in poudriere.jails %}

{% if jail.present|default(True) %}

poudriere_jail_{{ jail.label }}_update:
  cmd.run:
    - name: poudriere jail -u -j {{ jail.label }} -m {{ jail.method|default('http') }}
    - shell: /bin/sh
    - require:
      - file: poudriere_conf

{% endif %}

{% endfor %}
