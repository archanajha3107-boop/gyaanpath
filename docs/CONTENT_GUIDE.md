# Content Guide — Adding Solutions & PDFs

This guide is for **teachers and contributors**
who want to add solutions to GyaanPath.
No coding knowledge needed!

---

## Part 1 — Adding Textbook PDFs

### SSC Maharashtra Balbharati PDFs
All FREE and official from Maharashtra Government.

1. Go to https://ebalbharati.in
2. Select Class → Subject → Download PDF
3. Compress using: https://www.ilovepdf.com/compress_pdf
4. Rename file following this naming convention:

assets/pdfs/ssc/class_10/maths_part1.pdf
assets/pdfs/ssc/class_10/maths_part2.pdf
assets/pdfs/ssc/class_10/science_part1.pdf
assets/pdfs/ssc/class_10/science_part2.pdf
assets/pdfs/ssc/class_10/history.pdf
assets/pdfs/ssc/class_10/geography.pdf
assets/pdfs/ssc/class_10/english.pdf
assets/pdfs/ssc/class_10/hindi.pdf
assets/pdfs/ssc/class_10/marathi.pdf


### CBSE NCERT PDFs
1. Go to https://ncert.nic.in/textbook.php
2. Select Class and Subject
3. Download and compress
4. Place in `assets/pdfs/cbse/class_10/`

---

## Part 2 — Adding Solutions to Database

Solutions are stored as rows in the SQLite database.
To add solutions, you write them in a simple format
and we add them via a seed script.

### Solution Format
Subject:   Mathematics
Chapter:   1 - Real Numbers
Exercise:  Exercise 1.1
Q Number:  1
Question:  Use Euclid's division algorithm to find the
HCF of 135 and 225.
Solution:
Step 1: Apply Euclid's division lemma to 225 and 135.
225 = 135 × 1 + 90
Step 2: Apply to 135 and 90.
135 = 90 × 1 + 45
Step 3: Apply to 90 and 45.
90 = 45 × 2 + 0
Since remainder = 0, HCF = 45
Difficulty: medium


### Rules for Writing Solutions
- Use **bold** for important steps
- Number each step clearly
- Keep language simple (Class 10 level)
- For Maths: show every calculation step
- For Science: explain the concept briefly first
- For diagrams: describe it in words for now

---

## Part 3 — Priority Content Needed

### 🔴 HIGH PRIORITY (do these first)
- SSC Class 10 Maths Part 1 — All exercises
- SSC Class 10 Maths Part 2 — All exercises
- SSC Class 10 Science Part 1 — All exercises

### 🟡 MEDIUM PRIORITY
- SSC Class 10 Science Part 2
- SSC Class 10 History — All Q&A
- CBSE Class 10 Maths — All exercises

### 🟢 LOWER PRIORITY
- Class 9 all subjects
- Class 8 all subjects
- English grammar solutions
- Hindi solutions

---

## How to Submit Solutions

**Option A — GitHub Issue (easiest)**
1. Open GitHub Issues
2. Click "New Issue"
3. Use title: `[Solutions] SSC Class 10 Maths Ch.1`
4. Paste solutions in the format above
5. Submit — we will add them to the database

**Option B — Google Form**
Fill this form (link coming soon) and
a developer will add it to the database.

**Option C — Pull Request (for developers)**
Add solutions directly to `lib/database/seed_data.dart`

---

## Thank You! 🙏
Every solution you write helps a student
in a village who has no other resource.
Your name will be added to the contributors list.

