(function () {
  "use strict";

  const buttons = Array.from(document.querySelectorAll(".tab-btn"));
  const panels = Array.from(document.querySelectorAll(".tab-panel"));

  function activate(targetId, { updateHash = true } = {}) {
    const targetButton = buttons.find((b) => b.dataset.target === targetId);
    const targetPanel = panels.find((p) => p.id === targetId);
    if (!targetButton || !targetPanel) return;

    buttons.forEach((b) => {
      const isActive = b === targetButton;
      b.classList.toggle("is-active", isActive);
      b.setAttribute("aria-selected", isActive ? "true" : "false");
    });

    panels.forEach((p) => {
      const isActive = p === targetPanel;
      p.classList.toggle("is-active", isActive);
      p.setAttribute("aria-hidden", isActive ? "false" : "true");
    });

    if (updateHash) {
      const newHash = "#" + targetId;
      if (window.location.hash !== newHash) {
        history.replaceState(null, "", newHash);
      }
    }
  }

  buttons.forEach((btn) => {
    btn.addEventListener("click", () => activate(btn.dataset.target));
    btn.addEventListener("keydown", (event) => {
      const idx = buttons.indexOf(btn);
      let next = null;
      if (event.key === "ArrowRight") next = buttons[(idx + 1) % buttons.length];
      if (event.key === "ArrowLeft") next = buttons[(idx - 1 + buttons.length) % buttons.length];
      if (event.key === "Home") next = buttons[0];
      if (event.key === "End") next = buttons[buttons.length - 1];
      if (next) {
        event.preventDefault();
        next.focus();
        activate(next.dataset.target);
      }
    });
  });

  function handleHash() {
    const hash = window.location.hash.replace(/^#/, "");
    if (!hash) return;

    if (panels.some((p) => p.id === hash)) {
      activate(hash, { updateHash: false });
      return;
    }

    const shortMatch = hash.match(/^tab-(\d+)/i);
    if (shortMatch) {
      const panel = panels.find((p) => p.id.startsWith(`tab-${shortMatch[1]}-`));
      if (panel) activate(panel.id, { updateHash: false });
    }
  }

  window.addEventListener("hashchange", handleHash);
  handleHash();

  const yearEl = document.getElementById("year");
  if (yearEl) yearEl.textContent = String(new Date().getFullYear());
})();
