### A Pluto.jl notebook ###
# v0.16.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ c07ccbd2-df20-11eb-36e5-898ebc20afa3
using Plots, PlutoUI

# ╔═╡ 8eb6995c-2d0c-4113-8ccb-76f20867fff9
md"For simplicity, we store the centers as a $d \times n$ matrix, where each column is an $d$-dimensional vector representing a center. Consider a simple example with four centers."

# ╔═╡ 2cd556a9-1b07-401c-8806-400cf18e9e2a
X_example = [[0, 0] [1, 1] [-1, 1] [2, -1]]

# ╔═╡ 8ade3b46-9062-4869-8a23-17e84951364e
md"We can quickly compute the pairwise distance matrix between the centers."

# ╔═╡ 0d38ff39-7531-4773-8fc9-f0f7fe13eda1
md"If we take a vector of four radii, we can compute its objective and check whether there are any circles that overlap."

# ╔═╡ 3b3b21c6-1dfd-4193-9bec-70aafd3202ec
begin 
	r1slider = @bind r₁ Slider(0.001:0.1:3, show_value=true)
	r2slider = @bind r₂ Slider(0.001:0.1:3, show_value=true)
	r3slider = @bind r₃ Slider(0.001:0.1:3, show_value=true)
	r4slider = @bind r₄ Slider(0.001:0.1:3, show_value=true)
	
	md"""**Try to find the optimal value:**

	r₁: $r1slider 

	r₂: $r2slider
	
	r₃: $r3slider
	
	r₄: $r4slider"""
end

# ╔═╡ 833eedf4-e410-410e-ad9c-1eba9b23f6d1
r_example = [r₁, r₂, r₃, r₄]

# ╔═╡ 6f8c0c02-b223-4e8d-ae36-cb025749dc33
md"""

## Assignments

For this project, we consider a larger problem of about 1000 points.
"""

# ╔═╡ af5a7165-fbec-4d44-acf9-edc73632ca79
X = [484 800;
441 796;
485 794;
480 793;
522 791;
465 789;
419 787;
406 785;
474 785;
520 785;
540 784;
466 783;
519 782;
429 781;
464 781;
459 780;
480 779;
462 777;
583 774;
426 771;
456 771;
394 770;
579 770;
384 768;
511 768;
601 768;
464 767;
446 766;
493 766;
509 766;
571 766;
609 765;
587 764;
589 764;
410 763;
521 763;
575 763;
464 761;
580 761;
543 760;
594 760;
530 759;
414 758;
448 757;
430 756;
617 756;
626 756;
497 755;
507 755;
410 754;
497 754;
504 754;
506 754;
507 754;
533 754;
566 754;
437 753;
543 752;
563 752;
601 752;
610 752;
454 751;
513 750;
559 750;
566 750;
603 750;
465 748;
546 748;
413 747;
488 747;
491 747;
583 747;
500 746;
401 745;
528 745;
646 744;
454 743;
600 743;
444 742;
631 742;
486 739;
532 739;
490 738;
494 738;
546 738;
652 738;
545 737;
600 737;
437 736;
440 736;
631 736;
433 735;
508 735;
583 734;
613 734;
490 733;
562 733;
443 732;
503 731;
666 731;
566 730;
629 730;
451 728;
437 727;
567 727;
618 727;
541 726;
671 726;
454 725;
553 725;
600 725;
449 724;
477 724;
556 724;
574 724;
474 723;
499 723;
584 723;
584 722;
672 722;
588 721;
470 720;
471 720;
510 719;
523 719;
562 719;
665 717;
671 717;
520 716;
580 716;
620 715;
626 715;
667 715;
683 715;
585 714;
567 713;
497 712;
554 712;
559 712;
544 711;
549 711;
622 709;
674 709;
644 708;
595 707;
620 707;
519 706;
542 706;
603 706;
653 705;
593 703;
533 701;
547 701;
528 700;
518 699;
625 699;
609 697;
638 697;
696 697;
509 695;
604 695;
636 694;
666 694;
684 694;
526 693;
565 693;
619 693;
634 693;
669 692;
658 691;
677 690;
697 690;
570 688;
576 688;
607 688;
649 687;
678 687;
694 685;
534 684;
567 683;
671 683;
622 682;
665 682;
671 682;
682 682;
631 681;
573 680;
681 679;
650 675;
577 674;
593 673;
631 672;
602 670;
533 669;
619 669;
645 667;
620 665;
691 665;
659 662;
530 660;
701 659;
705 658;
664 657;
327 654;
331 648;
170 639;
328 639;
155 636;
158 636;
328 634;
181 632;
336 632;
519 630;
346 628;
174 627;
331 627;
149 626;
324 626;
178 625;
327 625;
334 625;
307 624;
167 622;
309 620;
185 618;
180 615;
154 614;
171 611;
319 609;
192 607;
325 607;
142 606;
145 606;
302 606;
335 606;
310 605;
178 601;
187 601;
345 600;
180 598;
146 597;
174 597;
180 597;
297 594;
152 591;
295 591;
330 591;
188 590;
330 590;
505 588;
318 587;
502 587;
157 584;
168 579;
159 577;
163 574;
312 574;
332 573;
187 572;
307 572;
151 571;
324 570;
142 569;
151 569;
180 568;
184 568;
180 566;
190 566;
176 565;
324 565;
188 563;
145 560;
157 560;
186 560;
192 560;
227 560;
182 559;
192 559;
300 559;
308 559;
159 558;
226 558;
266 558;
175 557;
206 557;
237 557;
159 555;
280 554;
159 553;
187 551;
240 551;
278 551;
311 551;
226 550;
490 550;
251 549;
273 549;
159 547;
165 547;
180 547;
188 546;
245 546;
310 546;
206 544;
236 544;
271 544;
159 542;
217 542;
161 541;
178 541;
192 541;
229 540;
273 540;
293 540;
307 540;
157 539;
239 538;
261 538;
296 537;
297 537;
287 534;
485 534;
173 533;
203 532;
227 532;
321 532;
248 531;
216 529;
245 529;
286 529;
154 527;
197 527;
477 527;
314 526;
136 523;
218 523;
282 523;
288 523;
472 522;
312 521;
248 519;
256 519;
194 518;
217 518;
221 518;
160 517;
206 517;
240 516;
162 514;
245 514;
209 513;
236 513;
237 513;
143 512;
131 511;
135 511;
153 510;
491 510;
454 509;
242 508;
284 508;
142 507;
249 507;
331 506;
340 506;
271 505;
293 505;
347 505;
466 505;
121 504;
332 504;
346 504;
213 503;
486 503;
277 501;
489 501;
487 500;
200 499;
240 498;
275 498;
489 498;
438 497;
45 496;
141 496;
280 496;
121 495;
344 495;
352 495;
135 494;
145 493;
294 493;
458 493;
64 492;
346 492;
255 491;
429 491;
481 491;
90 490;
121 489;
171 489;
335 489;
421 489;
486 488;
218 487;
442 487;
150 486;
422 486;
488 486;
256 485;
337 484;
106 483;
216 483;
123 482;
139 482;
186 482;
413 482;
478 482;
110 481;
112 481;
254 480;
352 480;
183 479;
304 479;
467 479;
217 478;
428 478;
272 477;
209 476;
218 476;
324 476;
227 475;
236 475;
336 475;
355 475;
266 474;
297 474;
222 473;
225 473;
248 473;
253 473;
281 473;
439 473;
102 472;
149 472;
236 472;
284 472;
310 472;
494 472;
405 471;
207 470;
470 470;
36 469;
54 469;
84 469;
102 469;
103 469;
126 469;
166 469;
213 469;
313 469;
466 469;
476 469;
124 468;
185 468;
273 468;
363 468;
270 467;
108 465;
285 465;
359 465;
488 465;
233 464;
252 464;
270 464;
432 464;
279 463;
313 463;
104 462;
175 462;
201 462;
212 462;
391 462;
474 462;
396 461;
146 460;
148 460;
397 460;
332 459;
364 459;
101 458;
370 458;
342 457;
369 453;
439 453;
109 452;
402 452;
438 451;
471 451;
478 451;
371 450;
365 449;
477 449;
479 449;
353 447;
381 447;
395 447;
27 446;
32 445;
129 445;
373 445;
154 443;
380 443;
93 442;
130 441;
94 440;
424 439;
335 438;
97 437;
180 437;
354 437;
128 436;
367 436;
145 435;
148 435;
366 434;
380 434;
428 434;
173 433;
87 432;
117 432;
440 432;
163 431;
191 431;
406 431;
209 430;
315 430;
292 429;
126 428;
363 428;
467 428;
301 427;
361 427;
274 426;
246 425;
324 425;
329 425;
445 425;
123 422;
452 422;
164 421;
384 421;
439 421;
263 420;
291 420;
329 420;
368 420;
73 419;
310 419;
154 418;
369 418;
376 418;
434 418;
360 417;
456 417;
288 416;
440 416;
373 415;
438 415;
174 414;
254 414;
331 414;
338 414;
347 414;
63 413;
246 412;
384 412;
65 411;
395 411;
128 410;
373 410;
387 410;
80 409;
340 409;
91 408;
80 407;
82 407;
367 407;
394 406;
431 406;
444 406;
61 405;
382 405;
123 403;
320 403;
326 403;
103 402;
81 401;
58 400;
149 400;
376 399;
115 398;
380 398;
332 397;
359 397;
99 396;
361 396;
449 396;
115 395;
122 395;
400 395;
451 395;
138 394;
116 393;
377 392;
382 392;
423 392;
82 391;
52 389;
90 389;
133 389;
413 387;
61 385;
360 385;
106 384;
357 384;
55 383;
78 382;
379 382;
385 382;
60 380;
121 380;
390 380;
391 380;
67 379;
379 378;
76 377;
99 376;
405 376;
406 376;
386 375;
99 373;
231 373;
387 373;
59 372;
427 372;
427 371;
95 370;
100 370;
403 369;
439 369;
370 368;
401 368;
245 367;
378 366;
61 364;
104 364;
215 363;
46 362;
90 362;
416 362;
422 360;
382 359;
414 359;
41 358;
28 357;
386 357;
424 357;
64 356;
426 356;
428 356;
39 354;
42 354;
59 354;
155 353;
300 353;
396 353;
430 353;
72 352;
298 352;
327 351;
139 350;
422 350;
95 349;
62 348;
41 347;
44 346;
137 344;
76 342;
57 341;
59 341;
67 341;
350 341;
388 341;
405 341;
101 339;
400 336;
46 333;
89 332;
45 331;
98 331;
395 331;
407 330;
60 329;
63 328;
269 326;
40 325;
50 324;
86 324;
262 320;
32 319;
32 318;
75 317;
290 317;
291 316;
191 315;
353 315;
99 314;
252 313;
81 311;
259 311;
71 310;
75 310;
372 310;
96 309;
288 309;
44 308;
359 308;
338 307;
355 305;
21 303;
40 303;
57 303;
25 302;
111 302;
112 302;
346 302;
105 301;
129 301;
53 300;
31 299;
103 299;
173 299;
112 298;
114 298;
126 298;
97 297;
114 297;
5 296;
59 295;
56 294;
97 294;
133 294;
6 293;
70 293;
118 292;
129 292;
135 292;
410 292;
384 291;
11 287;
58 287;
59 287;
66 287;
93 287;
19 285;
56 282;
60 282;
74 279;
415 277;
82 276;
52 274;
28 269;
72 268;
27 267;
52 267;
77 266;
63 265;
41 264;
21 263;
410 259;
18 257;
3 255;
415 255;
1 249;
37 248;
47 248;
417 247;
47 243;
24 242;
87 241;
18 240;
36 240;
72 235;
33 233;
40 233;
55 233;
8 232;
11 228;
36 228;
88 228;
49 225;
83 223;
31 220;
412 220;
29 218;
91 217;
84 212;
80 208;
84 208;
36 206;
22 205;
68 204;
78 204;
20 203;
32 201;
42 201;
62 201;
77 201;
50 199;
92 199;
78 198;
39 196;
406 196;
48 191;
46 189;
32 188;
60 187;
82 187;
26 186;
49 186;
61 186;
56 183;
31 182;
31 180;
45 177;
35 175;
393 175;
104 173;
68 172;
40 171;
405 170;
407 170;
79 169;
82 169;
38 165;
50 164;
39 161;
108 160;
57 159;
132 158;
47 156;
87 154;
101 154;
55 152;
81 152;
122 150;
125 150;
94 147;
125 147;
55 146;
58 145;
67 145;
372 142;
78 141;
149 141;
368 140;
121 137;
149 137;
366 137;
102 136;
143 136;
90 135;
99 134;
136 134;
142 133;
67 132;
149 131;
169 130;
390 130;
82 129;
160 129;
383 127;
104 126;
118 125;
99 123;
360 123;
146 120;
97 119;
112 118;
361 117;
376 117;
96 116;
61 115;
185 115;
69 114;
135 114;
150 112;
371 112;
117 110;
62 109;
165 109;
203 107;
366 107;
93 106;
190 106;
215 105;
341 105;
354 105;
326 104;
132 103;
146 103;
345 103;
115 102;
168 102;
183 102;
369 102;
229 101;
334 101;
111 100;
231 100;
353 100;
162 98;
262 98;
104 96;
273 96;
352 96;
260 94;
267 94;
308 94;
225 93;
117 91;
153 91;
253 91;
298 91;
344 91;
135 90;
159 90;
149 87;
317 87;
90 85;
217 85;
286 85;
99 84;
201 83;
259 83;
299 83;
322 82;
239 81;
257 81;
265 81;
159 79;
281 79;
140 78;
163 78;
170 77;
99 75;
140 75;
212 75;
295 75;
202 74;
317 74;
162 73;
167 73;
140 72;
161 72;
203 72;
311 71;
203 70;
293 70;
185 68;
266 68;
132 67;
195 67;
239 66;
263 65;
292 65;
311 65;
311 64;
296 62;
124 61;
312 61;
154 58;
149 57;
281 57;
307 57;
179 56;
223 55;
309 55;
278 54;
133 50;
294 50;
191 49;
246 49;
265 49;
283 46;
147 45;
260 45;
189 44;
254 43;
268 43;
285 42;
184 40;
164 39;
182 36;
167 35;
199 34;
258 34;
165 33;
256 33;
167 32;
202 31;
172 30;
225 30;
264 30;
269 29;
274 29;
280 27;
166 25;
175 25;
147 22;
252 22;
168 20;
283 17;
274 15;
270 12]' |> collect


# ╔═╡ 41c188f7-60e4-4895-8285-6862560d6fe1
n = size(X, 2)  # number of points

# ╔═╡ 5e9b39fd-d16d-4802-b83f-6e48033b7bab
scatter(X[1,:], X[2,:], label="", aspect_ratio=1, ms=1)

# ╔═╡ 1a598959-e152-4ccf-9dba-a12f92941546
md"""
Use your knowledge of optimization to generate the best solution that you can. Send your notebook to [me](michiel.stock@ugent.be), both as Pluto notebook file (.jl) and as **PDF or HTML file**. Also send your solution as a .CSV file. Use the function `save_solution` to generate this file. Use your name(s) in the file name!

You will be graded on two accounts:
- the quality of your solution relative to the other students;
- the originality and quality of your approach you used, including writing tidy code, adding documentation and comments.

Only strictly correct solutions count, so make sure no circles overlap!

There are many clever things possible to make it easier to solve.

You can do this project alone or in pairs. The deadline is **Friday 5 November 2021**.
"""

# ╔═╡ 70c7eba4-4c48-489d-98f0-fa363fb1de52
student_names = missing;  # add your name(s) here

# ╔═╡ 9a6f0ff5-70b3-46f6-ace7-ca763848984b
md"""
# Project: Circles

**STMO**

2021-2022

project by $student_names

## Outline

In this project, we will solve a geometric optimization problem. Given a set of $n$ centers of circles, determine their radius such that none of the circles intersect and the sum of logarithm of the surfaces is maximal.

$$\max_\mathbf{r}\, \sum_{i=1}^n \log r_i^2\pi$$




Subject to

$$r_i+r_j \le d(\mathbf{x}_i, \mathbf{x}_j)\quad \forall i,j$$

and

$$r_i \ge 0\quad \forall i\,.$$

The last constraint is already implied by the objective.

Here, $d(\mathbf{x}_i, \mathbf{x}_j)$ is the Euclidean distance between $\mathbf{x}_i$ and $\mathbf{x}_j$.

You can convince yourself that this is a convex optimization problem.
"""

# ╔═╡ 95bf9626-7892-4f8b-8198-00d00142a05c
md"For example, a simple solution might be to take half of the smallest distance between the points."

# ╔═╡ 4f704ed5-c51e-41b2-ad52-47a1c0f420a2
md"It's not very good, but at least it satisfies the constraints. Let's save it."

# ╔═╡ c8b57aca-04cf-4d02-a002-1be0a33e3283
md"Solve this problem below:"

# ╔═╡ ef47b569-c39d-4135-88d7-a6a1c0e41e59


# ╔═╡ 68634978-5d9a-4ba3-9c32-ff1fe547f98f


# ╔═╡ 06a5c72f-8724-4d0c-b114-27a98579502a


# ╔═╡ f376e25d-cc5a-4ae6-a89b-52b8b0a35b8c


# ╔═╡ 3da0c3f3-032a-47bb-950f-010dd1be8afd


# ╔═╡ 0005c9ae-f3bc-4a36-a830-267b4206d2fe


# ╔═╡ 2664c525-49d3-49fd-988d-1a58f41106fd


# ╔═╡ ad5714ba-dcef-4fd1-a1ae-85ebae4c9b9e


# ╔═╡ 47a050ef-0bf1-4ebb-9a99-6a98de958572


# ╔═╡ b5d999ff-a289-4ca1-bd87-faa07e5cb83e
md"
## Utilities
Functions to analyse and save the solution. Here be dragons 🐉, don't touch."

# ╔═╡ 9fdbfc20-f704-494a-bf29-19a92604da95
distances(X) = [√(sum((X[:,i].-X[:,j]).^2)) for i in 1:size(X,2), j in 1:size(X,2)]

# ╔═╡ b6db7362-05f9-4ed7-9f28-f9969943af76
D_example = distances(X_example)

# ╔═╡ 2a252459-19f6-4906-b9b9-349b922a7b86
D = distances(X)

# ╔═╡ f7d3f8e9-c1cd-4532-a000-5d448947de5c
r_min = 0.5minimum((D[i,j] for i in 2:n for j in 1:(i-1)))

# ╔═╡ 16ed4013-3baa-4fd3-b776-9a9684ff2edc
r_naive = fill(r_min, n)

# ╔═╡ 39bef477-45db-4b01-bcf1-a926f99ca592
function constraint_violations(X, r)
	@assert size(X, 2) == length(r)
	@assert all(r .≥ 0) "The radii have to be non-negative!" 
	n = length(r)
	D = distances(X)
	violated = zeros(Bool, n)
	for i in 1:n
		for j in 1:n
			if (i != j) && (D[i,j] < r[i] + r[j])
				violated[i] = true
			end
		end
	end
	return violated
end		

# ╔═╡ c6e0198f-86f5-4771-bcfa-5aa7a8f7acd7
constraint_violations(X_example, [0.1, 0.2, 0.4, 0.2])

# ╔═╡ 3f322455-01a1-4a8b-9024-202eac4bde10
objective(r) = sum(log.(r.^2 .* π))

# ╔═╡ 1f6db5e9-104b-4bc3-bef6-ad48f214dfe2
objective([0.1, 0.2, 0.4, 0.2])

# ╔═╡ 58c4c246-2eaf-400e-9c5f-82fd12380ee0
function save_solution(filename, r)
	open(filename, "w") do io
		for ri in r
			println(io, ri)
		end
	end
end

# ╔═╡ 718dfa36-83d9-40c4-a0b4-62bcc9771928
save_solution("mynaivesolution.csv", r_naive)

# ╔═╡ 00bb2366-4cbc-43c8-b5e3-7382324b0b69
begin
	myblue = "#304da5"
	mygreen = "#2a9d8f"
	myyellow = "#e9c46a"
	myorange = "#f4a261"
	myred = "#e76f51"
	myblack = "#50514F"

	mycolors = [myblue, myred, mygreen, myorange, myyellow]
end;

# ╔═╡ 75b4a3c5-9e3c-4bc3-ba2a-575f5bfc095f
"""
A simple function to plot the solution.
"""
function plot_circles(X, r; numbers=false)
	obj = objective(r)
	violated = constraint_violations(X, r)
	# draw centers
	p = scatter(X[1,:], X[2,:], label="", aspect_ratio=1, ms=1,
		title="objective = $obj \n $(sum(violated)) violations", color=mygreen)
	θ = range(0, 2π, length=50)  # for plotting the circle
	for (i, rᵢ) in enumerate(r)
		color = violated[i] ? myorange : myblue
		plot!(p, X[1,i] .+ rᵢ .* cos.(θ), X[2,i] .+ rᵢ .* sin.(θ),
			label="", color=color)
		numbers && annotate!(p, [(X[1,i], X[2,i], text(i))])
	end
	return p
end

# ╔═╡ ba14aac3-972d-4f5e-84e3-1bdebc4aac96
plot_circles(X_example, r_example, numbers=true)

# ╔═╡ 9e545339-c82e-4088-829c-f7a660fe15fc
plot_circles(X, r_naive)  # circles are so small you don't see them

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Plots = "~1.22.0"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "9995eb3977fbf67b86d0a0a0508e83017ded03f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.14.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "4866e381721b30fac8dda4c8cb1d9db45c8d2994"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.37.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "bec2532f8adb82005476c141ec23e921fc20971b"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.8.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "dba1e8614e98949abfa60480b13653813d8f0157"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "c2178cfbc0a5a552e16d097fae508f2024de61a3"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.59.0"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "ef49a187604f865f4708c90e3f431890724e9012"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.59.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7bf67e9a481712b3dbe9cb3dac852dc4b1162e02"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+0"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "60ed5f1643927479f845b0135bb369b031b541fa"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.14"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "8a954fed8ac097d5be04921d595f741115c1b2ad"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+0"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "761a393aeccd6aa92ec3515e428c26bf99575b3b"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+0"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "2537ed3c0ed5e03896927187f5f2ee6a4ab342db"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.14"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "b1a708d607125196ea1acf7264ee1118ce66931b"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.22.0"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8cbbc098554648c84f79a463c9ff0fd277144b6c"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.10"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "f41020e84127781af49fc12b7e92becd7f5dd0ba"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.2"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "1162ce4a6c4b7e31e0e6b14486a6986951c73be9"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.2"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─c07ccbd2-df20-11eb-36e5-898ebc20afa3
# ╟─9a6f0ff5-70b3-46f6-ace7-ca763848984b
# ╟─8eb6995c-2d0c-4113-8ccb-76f20867fff9
# ╠═2cd556a9-1b07-401c-8806-400cf18e9e2a
# ╟─8ade3b46-9062-4869-8a23-17e84951364e
# ╠═b6db7362-05f9-4ed7-9f28-f9969943af76
# ╟─0d38ff39-7531-4773-8fc9-f0f7fe13eda1
# ╠═1f6db5e9-104b-4bc3-bef6-ad48f214dfe2
# ╠═c6e0198f-86f5-4771-bcfa-5aa7a8f7acd7
# ╟─3b3b21c6-1dfd-4193-9bec-70aafd3202ec
# ╠═833eedf4-e410-410e-ad9c-1eba9b23f6d1
# ╠═ba14aac3-972d-4f5e-84e3-1bdebc4aac96
# ╟─6f8c0c02-b223-4e8d-ae36-cb025749dc33
# ╟─af5a7165-fbec-4d44-acf9-edc73632ca79
# ╠═41c188f7-60e4-4895-8285-6862560d6fe1
# ╟─5e9b39fd-d16d-4802-b83f-6e48033b7bab
# ╟─1a598959-e152-4ccf-9dba-a12f92941546
# ╠═70c7eba4-4c48-489d-98f0-fa363fb1de52
# ╟─95bf9626-7892-4f8b-8198-00d00142a05c
# ╠═2a252459-19f6-4906-b9b9-349b922a7b86
# ╠═f7d3f8e9-c1cd-4532-a000-5d448947de5c
# ╠═16ed4013-3baa-4fd3-b776-9a9684ff2edc
# ╠═9e545339-c82e-4088-829c-f7a660fe15fc
# ╟─4f704ed5-c51e-41b2-ad52-47a1c0f420a2
# ╠═718dfa36-83d9-40c4-a0b4-62bcc9771928
# ╟─c8b57aca-04cf-4d02-a002-1be0a33e3283
# ╠═ef47b569-c39d-4135-88d7-a6a1c0e41e59
# ╠═68634978-5d9a-4ba3-9c32-ff1fe547f98f
# ╠═06a5c72f-8724-4d0c-b114-27a98579502a
# ╠═f376e25d-cc5a-4ae6-a89b-52b8b0a35b8c
# ╠═3da0c3f3-032a-47bb-950f-010dd1be8afd
# ╠═0005c9ae-f3bc-4a36-a830-267b4206d2fe
# ╠═2664c525-49d3-49fd-988d-1a58f41106fd
# ╠═ad5714ba-dcef-4fd1-a1ae-85ebae4c9b9e
# ╠═47a050ef-0bf1-4ebb-9a99-6a98de958572
# ╟─b5d999ff-a289-4ca1-bd87-faa07e5cb83e
# ╠═39bef477-45db-4b01-bcf1-a926f99ca592
# ╠═9fdbfc20-f704-494a-bf29-19a92604da95
# ╠═3f322455-01a1-4a8b-9024-202eac4bde10
# ╠═75b4a3c5-9e3c-4bc3-ba2a-575f5bfc095f
# ╠═58c4c246-2eaf-400e-9c5f-82fd12380ee0
# ╟─00bb2366-4cbc-43c8-b5e3-7382324b0b69
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
