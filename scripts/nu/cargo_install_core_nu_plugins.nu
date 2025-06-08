# https://www.nushell.sh/book/plugins.html#core-plugins
# > Most package managers will automatically install the core plugins with Nushell. A notable exception, however, is cargo.
# > -- https://github.com/nushell/nushell.github.io/blob/211dae419906f0d0ac529f9f71cf184ed648e527/book/plugins.md?plain=1#L32
[
    nu_plugin_inc
    nu_plugin_polars
    nu_plugin_gstat
    nu_plugin_formats
    nu_plugin_query
] | each { cargo install $in --locked } | ignore
