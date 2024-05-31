document
  .querySelectorAll("a")
  .forEach(
    (el) => (el.href = el.href.replace("[local]", window.location.hostname))
  );
