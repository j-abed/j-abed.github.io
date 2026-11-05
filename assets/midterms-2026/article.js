document.querySelectorAll('.midterms-figure').forEach(figure => {
  const chart = figure.querySelector('.midterms-chart');
  const region = figure.querySelector('.midterms-chart-scroll');
  const detail = document.createElement('div');
  detail.className = 'midterms-detail';
  detail.setAttribute('role', 'status');
  detail.hidden = true;
  figure.append(detail);
  const points = Array.from(chart.querySelectorAll('[data-detail]'));
  let selected = -1;
  const show = point => {
    detail.textContent = point.dataset.detail;
    detail.hidden = false;
  };
  const hide = () => { detail.hidden = true; };
  chart.addEventListener('pointerover', event => {
    const point = event.target.closest('[data-detail]');
    if (point) show(point);
  });
  chart.addEventListener('pointerleave', hide);
  chart.addEventListener('click', event => {
    const point = event.target.closest('[data-detail]');
    if (point) show(point);
    else hide();
  });
  region.addEventListener('keydown', event => {
    if (event.key === 'Escape') return hide();
    if (!['ArrowRight', 'ArrowLeft'].includes(event.key) || !points.length) return;
    event.preventDefault();
    selected = (selected + (event.key === 'ArrowRight' ? 1 : -1) + points.length) % points.length;
    show(points[selected]);
    points[selected].scrollIntoView({ block: 'nearest', inline: 'nearest' });
  });
  region.addEventListener('blur', hide);
});