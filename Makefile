# ──────────────────────────────────────────────────────────────────────────────
#  MentorPro Portfolio — Makefile
#  Build static site từ MentorPro.md vào thư mục docs/ để deploy GitHub Pages.
# ──────────────────────────────────────────────────────────────────────────────

PYTHON  ?= python3
PORT    ?= 8000

OUT     := docs
SRC     := MentorPro.md
BUILD   := build.py
ASSETS  := assets
TPL     := templates/index.html

VENV    := .venv
PY      := $(VENV)/bin/python
PIP     := $(VENV)/bin/pip
STAMP   := $(VENV)/.installed

ASSET_FILES := $(shell find $(ASSETS) -type f 2>/dev/null)

.DEFAULT_GOAL := build

.PHONY: help build clean serve install deploy-info rebuild watch distclean

help: ## Hiển thị danh sách target
	@echo ""
	@echo "  MentorPro Portfolio — make targets"
	@echo "  ----------------------------------"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

$(STAMP): requirements.txt
	@command -v $(PYTHON) >/dev/null 2>&1 || { echo "✗ Không tìm thấy $(PYTHON). Cài Python 3 trước."; exit 1; }
	@test -d $(VENV) || { echo "▶ Tạo virtualenv $(VENV) ..."; $(PYTHON) -m venv $(VENV); }
	@echo "▶ Cài dependency ..."
	@$(PIP) install --quiet --upgrade pip
	@$(PIP) install --quiet -r requirements.txt
	@touch $(STAMP)
	@echo "✓ Sẵn sàng (venv: $(VENV))"

install: $(STAMP) ## Tạo venv và cài dependency vào .venv/

build: $(STAMP) $(OUT)/index.html ## Build site vào docs/ (mặc định)

$(OUT)/index.html: $(SRC) $(BUILD) $(TPL) $(ASSET_FILES)
	@echo "▶ Building $(SRC) → $(OUT)/ ..."
	@$(PY) $(BUILD)
	@echo "✓ Done. Mở $(OUT)/index.html hoặc chạy 'make serve'."

rebuild: clean build ## Xoá docs/ rồi build lại từ đầu

clean: ## Xoá thư mục docs/
	@rm -rf $(OUT)
	@echo "✓ Removed $(OUT)/"

distclean: clean ## Xoá cả docs/ và .venv/
	@rm -rf $(VENV)
	@echo "✓ Removed $(VENV)/"

serve: build ## Chạy local server tại http://localhost:$(PORT)
	@echo "▶ Serving $(OUT)/ at http://localhost:$(PORT)  (Ctrl+C để dừng)"
	@$(PY) -m http.server $(PORT) --directory $(OUT)

watch: $(STAMP) ## Rebuild tự động khi MentorPro.md / template / asset thay đổi
	@command -v fswatch >/dev/null 2>&1 || { echo "Cần cài fswatch: brew install fswatch"; exit 1; }
	@echo "▶ Watching for changes... (Ctrl+C để dừng)"
	@fswatch -o $(SRC) $(BUILD) $(TPL) $(ASSETS) | while read; do $(MAKE) --no-print-directory build; done

deploy-info: ## In hướng dẫn deploy lên GitHub Pages
	@echo ""
	@echo "  Deploy lên GitHub Pages"
	@echo "  -----------------------"
	@echo "  1. make rebuild"
	@echo "  2. git add docs MentorPro.md Makefile build.py templates assets requirements.txt README.md .gitignore"
	@echo "  3. git commit -m 'build: MentorPro portfolio site'"
	@echo "  4. git push origin main"
	@echo "  5. Trên GitHub: Settings → Pages → Source: 'Deploy from a branch'"
	@echo "                  Branch: main, Folder: /docs → Save"
	@echo "  6. Site sẽ live tại: https://<user>.github.io/<repo>/"
	@echo ""
