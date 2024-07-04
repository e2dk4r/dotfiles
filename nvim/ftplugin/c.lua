if vim.fn.filereadable('meson.build') == 1 and vim.fn.isdirectory('build/') then
  vim.bo.makeprg = 'ninja -j0 -C build/'
end
