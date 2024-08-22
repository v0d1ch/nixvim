{pkgs, inputs, opts, ...}:
{
  extraPlugins = with pkgs.vimPlugins; [ nvim-solarized-lua ];
}
