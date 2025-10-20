---
name: report-generator
description: Generate professional reports with standardized directory structure. Use when users request report creation, documentation generation, or organized output in dated folders. Creates reports in C:\tmp\Claude\[SkillName]\[YYYYMMDD]\ structure for easy organization and retrieval.
license: Complete terms in LICENSE.txt
---

# Report Generator

## Overview

This skill enables systematic creation of reports with standardized directory organization. Reports are automatically organized in date-stamped folders under `C:\tmp\Claude\[SkillName]\[YYYYMMDD]\` for easy tracking and retrieval.

## Directory Structure Standard

All reports follow this structure:

```
C:\tmp\                      → Temporary root (safe to delete entire folder)
├─ Claude\                   → Created by Claude (all Claude outputs)
   ├─ [SkillName]\           → Skill or project name
      └─ [YYYYMMDD]\         → Date stamp (e.g., 20251020)
         ├─ report.docx      → Main report file
         ├─ summary.md       → Quick reference
         ├─ data\            → Supporting data files
         └─ assets\          → Images, charts, etc.
```

### Directory Structure Benefits

- **Organized by date**: Easy to find recent work
- **Skill-specific**: Each skill/project has dedicated space
- **Temporary designation**: Clear that C:\tmp\ can be cleaned up
- **Consistent naming**: YYYYMMDD format sorts chronologically

## Workflow

### 1. Determine Report Type

Identify what kind of report is needed:
- Analysis report (data-driven insights)
- Status report (project updates)
- Research report (findings and recommendations)
- Documentation (technical or process docs)
- Custom report (user-defined structure)

### 2. Create Directory Structure

```python
import os
from datetime import datetime

# Get current date in YYYYMMDD format
date_stamp = datetime.now().strftime("%Y%m%d")

# Define base path
skill_name = "Update"  # or skill-specific name
base_path = f"C:\\tmp\\Claude\\{skill_name}\\{date_stamp}"

# Create directory structure
os.makedirs(base_path, exist_ok=True)
os.makedirs(f"{base_path}\\data", exist_ok=True)
os.makedirs(f"{base_path}\\assets", exist_ok=True)
```

### 3. Generate Report Content

Create the report using appropriate tool (docx, markdown, pdf):
- Use docx skill for Word documents
- Use markdown for technical documentation
- Use pptx skill for presentations
- Use pdf skill for final deliverables

### 4. Save Supporting Files

Organize related files:
- Raw data → `data\` subfolder
- Charts/images → `assets\` subfolder
- Quick summary → root as `summary.md`

## Common Report Patterns

### Pattern 1: Analysis Report

```
C:\tmp\Claude\Analysis\20251020\
├─ analysis_report.docx       → Main findings
├─ summary.md                  → Executive summary
├─ data\
│  ├─ raw_data.csv            → Source data
│  └─ processed_data.csv      → Cleaned data
└─ assets\
   ├─ chart1.png              → Visualizations
   └─ chart2.png
```

### Pattern 2: Status Update

```
C:\tmp\Claude\StatusUpdate\20251020\
├─ weekly_status.docx          → Status report
├─ summary.md                  → Key highlights
└─ assets\
   └─ timeline.png             → Visual timeline
```

### Pattern 3: Research Report

```
C:\tmp\Claude\Research\20251020\
├─ research_report.docx        → Full report
├─ summary.md                  → Key findings
├─ data\
│  └─ sources.md              → References
└─ assets\
   ├─ diagram1.png            → Supporting visuals
   └─ diagram2.png
```

## Usage Examples

### Example 1: Creating an Analysis Report

User: "Create an analysis report on the Q3 sales data"

Steps:
1. Run `scripts/create_report_structure.py Analysis` to create directory
2. Use docx skill to create analysis_report.docx
3. Create summary.md with key findings
4. Save charts to assets/
5. Save raw data to data/

### Example 2: Weekly Status Update

User: "Generate my weekly status report"

Steps:
1. Run `scripts/create_report_structure.py StatusUpdate`
2. Create weekly_status.docx with achievements, challenges, next steps
3. Create summary.md with highlights
4. Include any supporting visuals in assets/

### Example 3: Research Documentation

User: "Document my research findings on AI trends"

Steps:
1. Run `scripts/create_report_structure.py Research`
2. Use docx skill for comprehensive report
3. Store source references in data/sources.md
4. Save supporting diagrams to assets/
5. Create summary.md with abstract

## Helper Scripts

See `scripts/create_report_structure.py` for automated directory creation.

## Reference Materials


See `references/report_templates.md` for detailed report structure templates and formatting guidelines.

## Best Practices

1. **Always create the directory structure first** using the helper script or manual commands
2. **Use descriptive skill names** that reflect the report type or project
3. **Include summary.md** for quick reference and easy scanning
4. **Organize supporting files** in appropriate subfolders (data/, assets/)
5. **Follow consistent naming** conventions for files within each report
6. **Use appropriate tools** based on output format (docx, pptx, pdf, markdown)
