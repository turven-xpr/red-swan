import json
from pathlib import Path

content_path = Path("assets/deutschy_content.json")
with open(content_path, "r", encoding="utf-8") as f:
    d = json.load(f)

print(f"Total units in curriculum: {len(d['units'])}")
print(f"Total lessons: {len(d['lessons'])}")
print(f"Total exercises: {len(d['exercises'])}")
print(f"Total vocabulary words: {len(d['words'])}")
print("-" * 65)

a1_units = [u for u in d['units'] if u['level'] == 'A1']
print(f"Total A1 units: {len(a1_units)}")
for u in a1_units:
    uid = u['id']
    un = u['unit_number']
    title = u['title_de']
    # Check both unit_id == uid and unit_id == un
    lessons = [l for l in d['lessons'] if l.get('unit_id') == uid or l.get('unit_id') == un]
    ex_count = sum(len([e for e in d['exercises'] if e.get('lesson_id') == l['id']]) for l in lessons)
    words = [w for w in d['words'] if w.get('topic') == u.get('topic_key')]
    print(f"Unit {un:02d} (id: {uid}): {title:35s} | Lessons: {len(lessons)} | Exercises: {ex_count:2d} | Vocab: {len(words)}")
