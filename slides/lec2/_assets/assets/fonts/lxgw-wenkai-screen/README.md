# 霞鹜文楷屏幕阅读版：按需加载

来源：官方 [LXGW WenKai Screen v1.530](https://github.com/lxgw/LxgwWenKai-Screen/releases/tag/v1.530)
的 `LXGWWenKaiScreen.ttf`，与原 lec0 字体子集的版本一致。
字体许可证见上级目录的 `OFL-LXGWWenKai.txt`。
原始 TTF 的 SHA256：`abd13364163e3cd84372b333f2fdcee9efb848634668f1c0ce5788dcd059ee61`。

保留官方字体的全部 Unicode 字符，使用 FontTools 压缩为 WOFF2，
每片最多 256 个字符。`font.css` 的 `unicode-range` 让浏览器只请求
页面实际用到的分片；不依赖第三方 CDN，也不需要每次修改课件后重新收集汉字。
GB2312 一级常用汉字和其他字符分别分组，避免常用字与生僻字混在同一分片。
`font-display: swap` 允许字体加载期间先显示文字。

## 重新生成

正常编辑课件无需运行下面的命令。仅升级字体或修改分片策略时重新生成：

```powershell
python -m pip install fonttools brotli
# 从上述官方 release 下载 LXGWWenKaiScreen.ttf
python scripts/build-wenkai.py path/to/LXGWWenKaiScreen.ttf
```

生成的 `font.css` 与 `screen-*.woff2` 一起提交。
升级字体版本时应同时更新生成脚本中的版本注释和本文件的来源。
`assets/css/slides.css` 导入此目录的 CSS。
`make static` 和 GitHub Actions 都会将 `assets/fonts` 完整复制到导出目录。
原始 TTF 不需要提交或部署。
