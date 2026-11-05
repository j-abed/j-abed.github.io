const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const assert = require('node:assert/strict');

const root = path.resolve(__dirname, '../..');
const source = fs.readFileSync(path.join(root, 'source_info/midterms-2026-dashboard.html'), 'utf8');
const raw = JSON.parse(source.match(/window\.__MIDTERM_DATA__ = (\{[^\n]*\});/)[1]);
const library = source.match(/<script>(\/\/ https:\/\/d3js\.org[\s\S]*?)<\/script>/)[1];
const context = {};
vm.runInNewContext(library, context, { timeout: 5000 });
const d3 = context.d3;
const data = Object.fromEntries(Object.entries(raw).map(([key, csv]) => [key, Array.from(d3.csvParse(csv))]));
const colors = { ink: '#222825', muted: '#66716b', grid: '#e1e7e2', dem: '#2168b5', rep: '#c84e48', fit: '#13766c', paper: '#ffffff' };
const output = path.join(root, '_includes/midterms-2026');
fs.mkdirSync(output, { recursive: true });

const escape = value => String(value).replace(/[&<>"']/g, character => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&apos;' }[character]));
const number = value => value === '' || value == null ? NaN : Number(value);
const finite = value => Number.isFinite(number(value));
const margin = value => value === 0 ? 'Even' : `${value > 0 ? 'D' : 'R'}+${Math.abs(value).toFixed(0)}`;
const text = (horizontal, vertical, content, attributes = '') => `<text x="${horizontal}" y="${vertical}" ${attributes}>${escape(content)}</text>`;
const line = (left, top, right, bottom, attributes = '') => `<line x1="${left}" y1="${top}" x2="${right}" y2="${bottom}" ${attributes}/>`;
const point = (horizontal, vertical, fill, detail, radius = 4, attributes = '') => `<circle cx="${horizontal}" cy="${vertical}" r="${radius}" fill="${fill}" data-detail="${escape(detail)}" ${attributes}><title>${escape(detail)}</title></circle>`;
const svg = (id, title, description, height, content, width = 760) => `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" role="img" aria-labelledby="${id}-title ${id}-desc" class="midterms-chart" data-chart="${id}"><title id="${id}-title">${escape(title)}</title><desc id="${id}-desc">${escape(description)}</desc><style>text{font-family:"PT Sans",sans-serif;font-size:15px;fill:${colors.ink}}line{stroke:${colors.grid};stroke-width:1}.axis{fill:${colors.muted};font-size:14px}.heading{font-size:20px;font-weight:700}.label{font-size:16px}.detail{font-size:13px;fill:${colors.muted}}</style><rect width="${width}" height="${height}" fill="${colors.paper}"/>${content}</svg>\n`;
const save = (name, content) => fs.writeFileSync(path.join(output, `${name}.svg`), content);
const summary = key => data.summary.find(row => row.metric === key).value;
const median = number(data.swing_summary.find(row => row.office === 'House' && row.baseline === 'vs 2024 presidential').median_swing);
const house = data.house_races.filter(row => finite(row.margin_pres2024) && finite(row.margin_2026));
assert.equal(house.length, 412);
assert.equal(data.house_races.length, 435);
assert.equal(summary('uniform_swing_accuracy'), '95.7%');

function scatter(name, rows, options) {
  const height = 470;
  const left = 72, right = 732, top = 90, bottom = 392;
  const horizontal = d3.scaleLinear(options.horizontalDomain || d3.extent(rows, row => number(row[options.horizontalField])), [left, right]).nice();
  const vertical = d3.scaleLinear(options.verticalDomain || d3.extent(rows, row => number(row[options.verticalField])), [bottom, top]).nice();
  let content = text(22, 32, options.title, 'class="heading"') + text(22, 58, options.subtitle, 'class="detail"');
  for (const tick of horizontal.ticks(7)) {
    content += line(horizontal(tick), top, horizontal(tick), bottom);
    content += text(horizontal(tick), bottom + 26, options.horizontalFormat(tick), 'text-anchor="middle" class="axis"');
  }
  for (const tick of vertical.ticks(6)) {
    content += line(left, vertical(tick), right, vertical(tick));
    content += text(left - 12, vertical(tick) + 5, options.verticalFormat(tick), 'text-anchor="end" class="axis"');
  }
  content += text(right, 451, options.horizontalLabel, 'text-anchor="end" class="label"');
  content += text(left, 80, options.verticalLabel, 'class="axis"');
  const clip = `${name}-clip`;
  content += `<defs><clipPath id="${clip}"><rect x="${left}" y="${top}" width="${right - left}" height="${bottom - top}"/></clipPath></defs><g clip-path="url(#${clip})">`;
  for (const reference of options.references) {
    const domain = horizontal.domain();
    content += line(horizontal(domain[0]), vertical(reference.intercept + reference.slope * domain[0]), horizontal(domain[1]), vertical(reference.intercept + reference.slope * domain[1]), `style="stroke:${reference.color};stroke-width:2" stroke-dasharray="${reference.dash || 'none'}"`);
  }
  for (const row of rows) {
    const party = row.leader || row.winner_party;
    const color = party === 'D' ? colors.dem : colors.rep;
    const called = row.called === 'Y';
    content += point(horizontal(number(row[options.horizontalField])), vertical(number(row[options.verticalField])), called ? color : colors.paper, options.detail(row), 4, `stroke="${color}" stroke-width="1.3" opacity="0.8"`);
  }
  content += '</g>';
  save(name, svg(name, options.title, options.description, height, content));
}

scatter('uniform-swing', house, {
  title: 'Most districts moved in the same direction',
  subtitle: '412 districts | Dashed line: common 14.3-point Democratic shift',
  description: '2024 presidential margin against the preliminary 2026 House margin. The dashed line adds the observed 14.3-point Democratic swing. Hollow dots are uncalled races.',
  horizontalField: 'margin_pres2024', verticalField: 'margin_2026', horizontalFormat: margin, verticalFormat: margin,
  horizontalLabel: '2024 presidential margin', verticalLabel: '2026 House margin',
  references: [{ intercept: median, slope: 1, color: colors.fit, dash: '6 4' }],
  detail: row => `${row.district_id}: 2024 ${margin(number(row.margin_pres2024))}; 2026 ${margin(number(row.margin_2026))}; ${row.called === 'Y' ? 'called' : 'uncalled'}. Swing: ${number(row.swing_vs_pres2024).toFixed(1)} points toward Democrats.`
});

const estimates = [
  { label: 'Generic-ballot rule', value: number(data.uniform_swing.find(row => row.model.includes('generic-ballot')).dem_seats), color: colors.fit, detail: 'Pre-election inputs; implied swing +11.3 points' },
  { label: 'Observed-swing rule', value: number(summary('uniform_swing_seats')), color: colors.dem, detail: 'Hindsight fit; observed median swing +14.3 points' }
];
const tally = data.tally.find(row => row.office === 'House');
const calledPlusLeading = number(tally.dem_won) + number(tally.uncalled_dem_leading);
assert.equal(calledPlusLeading, 259);
let forecast = text(22, 32, 'One rule, two national inputs', 'class="heading"') + text(22, 58, 'Model-implied Democratic House seats | Same 2024 district baseline', 'class="detail"');
const seatScale = d3.scaleLinear([210, 275], [302, 714]);
for (const tick of [218, 230, 240, 250, 260, 270]) {
  forecast += line(seatScale(tick), 82, seatScale(tick), 232);
  forecast += text(seatScale(tick), 258, tick, 'text-anchor="middle" class="axis"');
}
estimates.forEach((estimate, index) => {
  const vertical = 119 + index * 82;
  forecast += text(22, vertical, estimate.label, 'class="label"') + text(22, vertical + 20, estimate.detail, 'class="detail"');
  forecast += point(seatScale(estimate.value), vertical, estimate.color, `${estimate.label}: ${estimate.value} Democratic seats. ${estimate.detail}.`, 8);
  forecast += text(seatScale(estimate.value) + 16, vertical + 5, estimate.value, 'class="label"');
});
forecast += text(22, 298, '19-seat difference. Observed-swing fit is retrospective, not a forecast.', 'class="detail"');
save('seat-forecasts', svg('seat-forecasts', '243 versus 262 Democratic seats from the same rule', 'Generic-ballot input: 243 Democratic seats. Observed-swing input: 262. These are model estimates, not official results. The 19-seat difference reflects only the national input. The seat axis begins at 210; 218 seats are needed for a majority.', 320, forecast));

const historical = JSON.parse(fs.readFileSync(path.join(__dirname, 'historical-comparison.json'), 'utf8'));
const signedSeats = value => value > 0 ? `+${value}` : value < 0 ? `\u2212${Math.abs(value)}` : '0';
const currentHistory = historical.elections.find(row => row.year === 2026);
for (const office of ['House', 'Senate']) {
  const calls = data.tally.find(row => row.office === office);
  assert.equal(currentHistory[office.toLowerCase()], number(calls.rep_flips) - number(calls.dem_flips));
}
assert.equal(historical.elections.length, 7);
let historicalTable = '<table class="midterms-history-table"><caption>How Recent Midterms Compare</caption><thead><tr><th scope="col">Election</th><th scope="col">President</th><th scope="col">House seats</th><th scope="col">Senate seats</th></tr></thead><tbody>';
const tableYears = [1994, 2006, 2010, 2018, 2026];
const historicalRows = historical.elections.filter(row => tableYears.includes(row.year));
assert.equal(historicalRows.length, 5);
for (const row of historicalRows) {
  const qualification = row.provisional ? ' net flips called<br><small>Preliminary</small>' : '';
  const status = row.provisional ? '<br><small>Incomplete snapshot</small>' : '';
  historicalTable += `<tr><th scope="row">${row.year}${status}</th><td>${escape(row.president)}</td><td>${signedSeats(row.house)}${qualification}</td><td>${signedSeats(row.senate)}${qualification}</td></tr>`;
}
historicalTable += '</tbody></table>\n';
fs.writeFileSync(path.join(output, 'historical-table.html'), historicalTable);

let historyChart = text(22, 32, 'How Midterm House Seat Losses Compare', 'class="heading"') + text(22, 58, "President's party / Seats, not vote swing", 'style="font-size:15px"');
const historicalScale = d3.scaleLinear([-70, 15], [178, 566]);
const historicalZero = historicalScale(0);
historyChart += `<defs><pattern id="historical-provisional" width="8" height="8" patternUnits="userSpaceOnUse"><path d="M-2 2L2-2M0 8L8 0M6 10L10 6" style="stroke:${colors.fit};stroke-width:1.5;opacity:0.45"/></pattern></defs>`;
for (const tick of [-60, -40, -20, 0, 10]) {
  historyChart += line(historicalScale(tick), 80, historicalScale(tick), 403, tick === 0 ? `style="stroke:${colors.ink};stroke-width:2"` : '');
  historyChart += text(historicalScale(tick), 428, signedSeats(tick), 'text-anchor="middle" style="font-size:16px"');
}
historical.elections.forEach((row, index) => {
  const vertical = 100 + index * 45;
  const position = historicalScale(row.house);
  const detail = `${row.year}, ${row.president}: president's party ${signedSeats(row.house)} House seats.${row.provisional ? ' Net called flips in the unverified November 4 snapshot, not a final result.' : ' Historical election net change, American Presidency Project.'}`;
  historyChart += text(22, vertical, row.year, 'style="font-size:17px;font-weight:700"');
  historyChart += text(22, vertical + 20, row.president, 'style="font-size:14px"');
  historyChart += `<rect x="${Math.min(position, historicalZero)}" y="${vertical - 8}" width="${Math.abs(position - historicalZero)}" height="20" fill="${row.provisional ? 'url(#historical-provisional)' : '#7d8881'}" ${row.provisional ? `stroke="${colors.fit}" stroke-width="2"` : ''} data-detail="${escape(detail)}"><title>${escape(detail)}</title></rect>`;
  historyChart += text(position + (row.house < 0 ? -9 : 9), vertical + 7, signedSeats(row.house), `text-anchor="${row.house < 0 ? 'end' : 'start'}" style="font-size:18px;fill:${row.provisional ? colors.fit : colors.ink}"`);
});
historyChart += text(178, 456, 'Seats lost', 'style="font-size:16px"') + text(566, 456, 'Gained', 'text-anchor="end" style="font-size:16px"');
save('historical-seats', svg('historical-seats', 'How Midterm House Seat Losses Compare', 'Net House seats for the sitting president\'s party: 1994 minus 54; 1998 plus 4; 2002 plus 8; 2006 minus 30; 2010 minus 63; 2018 minus 41. The outlined, hatched 2026 bar shows minus 35 net called flips in the unverified November 4 snapshot, not a final result or projection. These are seats, not vote swings.', 472, historyChart, 600).replace('class="midterms-chart"', 'class="midterms-chart midterms-history-chart"'));

const polls = data.state_races.filter(row => finite(row.margin_poll) && finite(row.poll_error) && finite(row.margin_2026) && !/PollCheck/.test(row.poll_avg_source || ''));
assert.equal(polls.length, 34);
assert.equal(polls.filter(row => number(row.poll_error) > 0).length, 30);
const errorDomain = [Math.floor(d3.min(polls, row => number(row.poll_error)) / 2) * 2, Math.ceil(d3.max(polls, row => number(row.poll_error)) / 2) * 2];
const errorBands = d3.bin().value(row => number(row.poll_error)).domain(errorDomain).thresholds(d3.range(errorDomain[0] + 2, errorDomain[1], 2))(polls);
assert.equal(errorBands.reduce((count, band) => count + band.length, 0), polls.length);
const errorScale = d3.scaleLinear(errorDomain, [72, 714]);
const errorBottom = Math.max(230, 110 + d3.max(errorBands, band => band.length) * 18);
const meanError = number(data.poll_error.find(row => row.office === 'All').mean_signed_error);
let errors = text(22, 32, 'Most polling errors understated Democrats', 'class="heading"') + text(22, 58, '34 Senate and governor races | 30 positive errors, 4 negative errors', 'class="detail"');
for (const tick of d3.range(errorDomain[0], errorDomain[1] + 1, 2)) {
  errors += line(errorScale(tick), 106, errorScale(tick), errorBottom, tick === 0 ? `style="stroke:${colors.ink};stroke-width:2"` : '');
  errors += text(errorScale(tick), errorBottom + 26, `${tick > 0 ? '+' : ''}${tick}`, 'text-anchor="middle" class="axis"');
}
errors += line(errorScale(meanError), 106, errorScale(meanError), errorBottom, `style="stroke:${colors.fit};stroke-width:2" stroke-dasharray="5 4"`);
errors += text(errorScale(meanError) + 10, 91, `Mean: +${meanError.toFixed(1)} points`, 'class="detail"');
for (const band of errorBands) {
  band.sort((first, second) => first.race_id.localeCompare(second.race_id));
  band.forEach((row, index) => {
    const error = number(row.poll_error);
    const color = error > 0 ? colors.dem : colors.rep;
    const detail = `${row.race_id}: signed polling error ${error.toFixed(1)} points; poll ${margin(number(row.margin_poll))}; result ${margin(number(row.margin_2026))}. ${row.called === 'Y' ? 'Called' : 'Uncalled'}.`;
    errors += point(errorScale((band.x0 + band.x1) / 2), errorBottom - 8 - index * 18, row.called === 'Y' ? color : colors.paper, detail, 5, `stroke="${color}" stroke-width="1.5"`);
  });
}
errors += text(714, errorBottom + 59, 'Result minus poll, Democratic margin points', 'text-anchor="end" class="label"');
errors += text(22, errorBottom + 86, 'One dot per race, grouped in 2-point bands. Positive means Democrats outperformed.', 'class="detail"');
save('polling-error', svg('polling-error', 'Distribution of state-race polling errors', '34 qualifying Senate and governor races: 30 positive errors and four negative errors. Dots are stacked in two-point error bands. Positive errors mean polls understated Democrats. The dashed line marks the supplied mean of 5.3 points; hollow dots are uncalled races.', errorBottom + 108, errors));

let calibration = text(22, 32, 'Republican-favored categories shifted together', 'class="heading"') + text(22, 58, 'Filled dot: observed Democratic win rate | Hollow dot: conventional probability', 'class="detail"');
const probability = d3.scaleLinear([0, 1], [230, 660]);
const raters = [...new Set(data.calibration.filter(row => row.rater.endsWith('(House)')).map(row => row.rater))];
assert.equal(raters.length, 4);
raters.forEach((rater, raterIndex) => {
  const start = 92 + raterIndex * 128;
  calibration += text(22, start, rater, 'class="label" font-weight="700"');
  const buckets = data.calibration.filter(row => row.rater === rater && ['Lean R', 'Likely R', 'Solid R'].includes(row.rating)).sort((first, second) => ['Lean R', 'Likely R', 'Solid R'].indexOf(first.rating) - ['Lean R', 'Likely R', 'Solid R'].indexOf(second.rating));
  buckets.forEach((row, bucketIndex) => {
    const vertical = start + 30 + bucketIndex * 28;
    const actual = number(row.dem_win_rate), implied = number(row.implied_p);
    calibration += text(22, vertical + 5, row.rating) + text(135, vertical + 5, `n=${row.called}`, 'class="detail"');
    calibration += line(probability(0), vertical, probability(1), vertical);
    calibration += line(probability(implied), vertical, probability(actual), vertical, `style="stroke:${colors.dem};stroke-width:3"`);
    calibration += point(probability(implied), vertical, 'white', `${rater}, ${row.rating}: analyst-imposed Democratic probability ${Math.round(implied * 100)}%.`, 6, `stroke="${colors.muted}" stroke-width="2"`);
    calibration += point(probability(actual), vertical, colors.dem, `${rater}, ${row.rating}: Democrats won ${row.dem_wins} of ${row.called} called races (${Math.round(actual * 100)}%).`, 7);
    calibration += text(730, vertical + 5, `${Math.round(actual * 100)}%`, 'text-anchor="end"');
  });
});
for (const tick of [0, 0.25, 0.5, 0.75, 1]) calibration += text(probability(tick), 608, `${tick * 100}%`, 'text-anchor="middle" class="axis"');
calibration += text(22, 644, 'Probabilities are analytical assumptions, not the raters\' published odds.', 'class="detail"');
save('rating-calibration', svg('rating-calibration', 'Republican-favored House rating calibration', 'For each of four raters, observed Democratic win rates in Lean R, Likely R, and Solid R seats are compared with conventional category probabilities. Each row reports its called-race sample size.', 664, calibration));

const demographics = data.house_races.filter(row => row.demo_valid === 'Y' && finite(row.pct_white) && finite(row.swing_vs_pres2024));
assert.equal(demographics.length, 253);
scatter('demographics', demographics, {
  title: 'An association, not a voter-behavior explanation', subtitle: '253 unchanged-line districts | Reported correlation: -0.30 | Hollow dots: uncalled',
  description: 'Non-Hispanic white population share against Democratic district swing. The supplied univariate association is negative. District aggregates cannot identify individual turnout or persuasion.',
  horizontalField: 'pct_white', verticalField: 'swing_vs_pres2024', horizontalDomain: [0, 100], horizontalFormat: value => `${value}%`, verticalFormat: value => `${value > 0 ? '+' : ''}${value}`,
  horizontalLabel: 'Non-Hispanic white population share', verticalLabel: 'Democratic swing (points)', references: [],
  detail: row => `${row.district_id}: non-Hispanic white share ${number(row.pct_white).toFixed(1)}%; Democratic swing ${number(row.swing_vs_pres2024).toFixed(1)} points. ${row.called === 'Y' ? 'Called' : 'Uncalled'}.`
});

const genericSeats = estimates.find(estimate => estimate.label === 'Generic-ballot rule').value;
const observedSeats = estimates.find(estimate => estimate.label === 'Observed-swing rule').value;
const signedPollingError = number(data.poll_error.find(row => row.office === 'All').mean_signed_error).toFixed(1);
const graphicText = (horizontal, vertical, content, size = 26, attributes = '') => text(horizontal, vertical, content, `font-size="${size}" ${attributes}`);
const infographicHeadline = 'What Everyone Missed About the 2026 Midterms';
const infographicDescription = 'The supplied November 4, 2026 snapshot shows a 14.3-point median Democratic House district swing. The same model implies 243 Democratic seats with pre-election inputs and 262 with the observed swing: a 19-seat difference, not official results. Its 95.7 percent classification accuracy across 392 called House races is retrospective and in-sample, not a pre-election forecast. External sources remain unverified.';
const graphicOpening = (height, id) => `<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="${height}" viewBox="0 0 1200 ${height}" role="img" aria-labelledby="${id}-title ${id}-description"><title id="${id}-title">${escape(infographicHeadline)}</title><desc id="${id}-description">${escape(infographicDescription)}</desc><style>text{font-family:"Trebuchet MS",sans-serif;fill:#222825}.serif{font-family:Georgia,serif}.muted{fill:#66716b}.green{fill:#13766c}.blue{fill:#2168b5}.white{fill:white}</style><rect width="1200" height="${height}" fill="#fff"/>`;
const metrics = [
  { horizontal: 76, value: `+${median.toFixed(1)}`, label: 'Observed D swing', note: 'Median / 412 districts', color: 'green' },
  { horizontal: 468, value: summary('uniform_swing_accuracy'), label: 'Retrospective accuracy', note: '392 called House races', color: 'blue' },
  { horizontal: 855, value: `+${signedPollingError}`, label: 'Polling miss toward D', note: '34 Senate + governor races', color: 'green' }
];
const seatDifference = observedSeats - genericSeats;
assert.equal(seatDifference, 19);
const calledRaces = data.house_races.filter(row => row.called === 'Y');
const correctClassifications = calledRaces.filter(row => (number(row.margin_pres2024) + median > 0 ? 'D' : 'R') === row.winner_party).length;
assert.equal(calledRaces.length, 392);
assert.equal(`${(100 * correctClassifications / calledRaces.length).toFixed(1)}%`, summary('uniform_swing_accuracy'));
let graphic = graphicOpening(1500, 'summary');
graphic += '<rect x="76" y="41" width="38" height="5" fill="#13766c"/>';
graphic += graphicText(130, 55, 'DATA SCIENCE / 2026 MIDTERMS', 25);
graphic += graphicText(76, 145, 'What Everyone Missed', 78, 'class="serif"');
graphic += graphicText(76, 237, 'About the 2026', 78, 'class="serif"');
graphic += graphicText(76, 329, 'Midterms', 78, 'class="serif"');
graphic += graphicText(76, 388, 'The forecasts anticipated Democratic gains.', 36);
graphic += graphicText(76, 434, 'They underestimated how large those gains could be.', 36);
graphic += '<rect x="0" y="465" width="1200" height="280" fill="#edf4ef"/>';
graphic += graphicText(76, 567, median.toFixed(1), 120, 'class="green"');
graphic += graphicText(76, 638, 'point median Democratic swing', 43, 'class="serif"');
graphic += graphicText(76, 684, 'The typical House district shifted toward Democrats', 36);
graphic += graphicText(76, 729, 'relative to its 2024 presidential margin.', 36);
graphic += line(599, 785, 599, 990, 'stroke="#cfd9d2" stroke-width="2"');
graphic += graphicText(76, 785, 'Pre-election swing estimate', 34);
graphic += graphicText(650, 785, 'Observed swing', 34);
graphic += graphicText(76, 832, '+11.3 points', 38, 'class="green"');
graphic += graphicText(650, 832, `+${median.toFixed(1)} points`, 38, 'class="blue"');
graphic += graphicText(76, 927, genericSeats, 88, 'class="green"');
graphic += graphicText(650, 927, observedSeats, 88, 'class="blue"');
graphic += graphicText(76, 984, 'Democratic seats', 38);
graphic += graphicText(650, 984, 'Democratic seats', 38);
graphic += graphicText(76, 1030, 'Model-implied seat counts, not official election results.', 36);
graphic += graphicText(76, 1103, `${seatDifference}-seat difference`, 62, 'class="serif"');
graphic += graphicText(76, 1152, 'Same model. Different information.', 38, 'class="muted"');
graphic += graphicText(76, 1230, summary('uniform_swing_accuracy'), 68, 'class="blue"');
graphic += graphicText(350, 1200, 'of called House races', 38);
graphic += graphicText(350, 1244, 'correctly classified', 38);
graphic += graphicText(76, 1293, '392 called races. Retrospective, in-sample result.', 36);
graphic += graphicText(76, 1336, 'Observed swing, not a pre-election forecast.', 36);
graphic += '<rect x="0" y="1357" width="1200" height="143" fill="#edf4ef"/>';
graphic += graphicText(76, 1398, "The challenge wasn't just predicting who would win.", 34, 'class="serif"');
graphic += graphicText(76, 1441, 'It was estimating the size of the shift.', 34, 'class="serif"');
graphic += graphicText(76, 1480, 'Nov 4, 2026 / Unverified supplied snapshot / Jason Abed', 26);
graphic += '</svg>\n';
fs.writeFileSync(path.join(__dirname, 'summary.svg'), graphic);

let landscape = graphicOpening(700, 'summary-blog');
landscape += '<rect x="0" y="0" width="1200" height="258" fill="#f4f8f5"/><rect x="64" y="33" width="32" height="4" fill="#13766c"/>';
landscape += graphicText(112, 45, 'DATA SCIENCE / 2026 MIDTERMS', 21);
landscape += graphicText(64, 120, 'What the Forecasts Missed', 66, 'class="serif"');
landscape += graphicText(64, 198, 'About the 2026 Midterms', 66, 'class="serif"');
landscape += graphicText(64, 242, 'One model. Different information. A 19-seat gap.', 28, 'class="muted"');
metrics.forEach((metric, index) => {
  const horizontal = 64 + index * 386;
  landscape += graphicText(horizontal, 344, metric.value, 70, `class="${metric.color}"`);
  landscape += graphicText(horizontal, 391, metric.label, 26);
  landscape += graphicText(horizontal, 428, metric.note, 23, 'class="muted"');
});
landscape += line(64, 459, 1136, 459, 'stroke="#cfd9d2"');
landscape += graphicText(64, 506, 'PRE-ELECTION INPUTS', 23, 'class="muted"');
landscape += graphicText(650, 506, 'FITTED AFTER RESULTS', 23, 'class="muted"');
landscape += graphicText(64, 553, `+11.3 points / ${genericSeats} D seats`, 34, 'class="green"');
landscape += graphicText(650, 553, `+${median.toFixed(1)} points / ${observedSeats} D seats`, 34, 'class="blue"');
landscape += graphicText(64, 592, `Snapshot: ${calledPlusLeading} D seats called or leading. Not a final result.`, 23);
landscape += graphicText(64, 631, 'Accuracy is a hindsight fit, not a forecast.', 23);
landscape += graphicText(64, 673, 'Preliminary Nov 4, 2026 / External sources unverified', 21, 'class="muted"');
landscape += graphicText(1136, 673, 'Jason Abed', 23, 'text-anchor="end"');
landscape += '</svg>\n';
fs.writeFileSync(path.join(__dirname, 'summary-blog.svg'), landscape);
fs.writeFileSync(path.join(__dirname, 'snapshot.json'), JSON.stringify({ source: 'source_info/midterms-2026-dashboard.html', snapshot: summary('snapshot'), externallyVerified: false, data }, null, 2) + '\n');
console.log(`Built six native SVG figures, the historical table, and portrait/landscape infographics from ${house.length} districts, ${polls.length} polled races, and ${demographics.length} demographic profiles.`);