# MentorPro Portfolio

Portfolio tĩnh giới thiệu **MentorPro** — nền tảng mentor 1-1 với mentor từ Big Tech. Nội dung được viết trong `MentorPro.md` và build ra thư mục `docs/` để deploy lên **GitHub Pages**.

## Cấu trúc dự án

```
.
├── MentorPro.md          # Nội dung chính (4 tab: Mentor / Câu chuyện / Lộ trình / Liên hệ)
├── Makefile              # build / clean / serve / deploy-info
├── build.py              # Parse Markdown, render HTML có tab thật
├── templates/
│   └── index.html        # HTML template
├── assets/
│   ├── style.css         # CSS (hero gradient, tabs, bảng, responsive)
│   └── script.js         # Tab switching + keyboard nav + URL hash
├── docs/                 # ⬅ Output build — GitHub Pages serve từ đây
└── requirements.txt      # markdown>=3.6
```

## Yêu cầu

- Python ≥ 3.9
- `make`
- (tuỳ chọn) `fswatch` cho `make watch` — cài qua `brew install fswatch`

## Cách dùng

```bash
make install   # cài thư viện markdown
make build     # build site vào docs/
make serve     # mở http://localhost:8000
make clean     # xoá docs/
make rebuild   # clean + build
make watch     # tự rebuild khi sửa MD/template/asset
make help      # xem toàn bộ target
```

Sau khi build, mở `docs/index.html` hoặc truy cập `http://localhost:8000` (sau `make serve`).

## Deploy GitHub Pages

1. Commit & push toàn bộ (gồm cả thư mục `docs/`):

   ```bash
   git add MentorPro.md Makefile build.py templates assets requirements.txt docs README.md .gitignore
   git commit -m "build: MentorPro portfolio site"
   git push origin main
   ```

2. Trên GitHub: vào **Settings → Pages**
   - **Source:** `Deploy from a branch`
   - **Branch:** `main`, **Folder:** `/docs`
   - Bấm **Save**

3. Sau ~1 phút, site sẽ live tại:

   ```
   https://<github-username>.github.io/<repo-name>/
   ```

> Mẹo: chạy `make deploy-info` để in lại các bước này bất kỳ lúc nào.

### Dùng custom domain (tuỳ chọn)

Tạo file `assets/CNAME` chứa domain (vd. `mentorpro.vn`). Build lại — file sẽ được copy vào `docs/CNAME`, GitHub Pages tự nhận diện.

## Chỉnh sửa nội dung

Toàn bộ nội dung sống trong `MentorPro.md`. Cấu trúc bắt buộc: mỗi tab bắt đầu bằng heading dạng

```markdown
# Tab 1 — Thông tin Mentor
... nội dung ...

# Tab 2 — Câu chuyện thành công
...
```

`build.py` sẽ tự tách tab dựa trên regex `# Tab N — ...` (em-dash hoặc gạch ngang đều được).

Đổi style → sửa `assets/style.css`. Đổi layout / hero → sửa `templates/index.html`.

## Ghi chú

- File `.nojekyll` được tự tạo trong `docs/` để GitHub Pages không xử lý qua Jekyll.
- Nội dung mentor/học viên/số liệu hiện tại là **dữ liệu mẫu**, thay bằng số liệu thật trước khi publish.
