{pkgs, inputs, opts, ...}:
{
  extraPlugins = with pkgs.vimPlugins; [ papercolor-theme ];
}
