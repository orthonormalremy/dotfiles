# ensure nushell default plugins are installed (not included in the cargo install)
# https://www.nushell.sh/book/plugins.html#core-plugins
[
    nu_plugin_inc
    nu_plugin_polars
    nu_plugin_gstat
    nu_plugin_formats
    nu_plugin_query
] | each { cargo install $in --locked } | ignore
