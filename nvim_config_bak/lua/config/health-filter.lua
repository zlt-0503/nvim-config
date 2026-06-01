local health = vim.health

if health and not health._nvim_config_warn_filter then
  health._nvim_config_warn_filter = true
  health._nvim_config_warn = health.warn
  health.warn = function() end
  health.report_warn = health.warn
end
