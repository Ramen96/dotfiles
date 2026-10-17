-- Show images inside Neovim using Ghostty's image support (the kitty graphics protocol).
-- Opening a .png, .jpg, .gif, .webp, .heic, etc. displays the image instead of its bytes,
-- and images linked in markdown are previewed too. Non-PNG files are converted with
-- ImageMagick (`magick`, installed via Homebrew). PDFs also need Ghostscript (`gs`).
return {
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,
      },
    },
  },
}
