include:
  - poudriere.install
  - poudriere.config

{% set poudriere = salt.pillar.get('poudriere') %}

{% for jail in poudriere.jails %}
{% if jail.present|default(True) %}
poudriere_jail_{{ jail.label }}:
  cmd.run:
    - name: poudriere jail -c -j {{ jail.label }} -v {{ jail.version }} -m {{ jail.method|default('http') }}
    - shell: /bin/sh
    - unless: poudriere jail -i -j {{ jail.label }}
    - require:
      - file: poudriere_conf
{% else %}
poudriere_jail_{{ jail.label }}:
  cmd.run:
    - name: poudriere jail -d -j {{ jail.label }}
    - shell: /bin/sh
    - onlyif: poudriere jail -i -j {{ jail.label }}
    - require:
      - file: poudriere_conf
{% endif %}
{% endfor %}
