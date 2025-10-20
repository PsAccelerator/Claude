---
name: create-psaccelerator-word-document
description: Creates professional Word documents using PsAccelerator branding (green #008000, Arial fonts, clean design). Automatically applies brand colors, typography, and formatting standards for documents, reports, proposals, and presentations.
---

# Create PsAccelerator Word Document

## Overview
This skill creates professional Word documents using PsAccelerator's official branding. It applies consistent colors, typography, and design standards automatically.

## Brand Guidelines

### Colors
- **Primary Green**: `#008000` (RGB: 0, 128, 0)
- **Light Green** (backgrounds): `#D5F0D5`
- **Dark Gray**: `#333333`
- **Black**: `#000000`
- **White**: `#FFFFFF`

### Typography
- **Font**: Arial (all text)
- **Title**: 48pt, bold, green (#008000), centered
- **Heading 1**: 32pt, bold, green (#008000)
- **Heading 2**: 26pt, bold, dark gray (#333333)
- **Body Text**: 22pt (11pt in Word), regular, black

### Company Information
- **Name**: PsAccelerator
- **Tagline**: "Het bieden van de snelste weg naar een oplossing"
- **Founded**: 2006
- **Specialization**: Microsoft technologies and automation solutions
- **Website**: psaccelerator.nl
- **Email**: info@psaccelerator.nl

## Usage

When a user requests a PsAccelerator branded document, follow this workflow:


### Step 1: Create JavaScript file
Create a Node.js script using the template below. Customize the content sections as needed.

### Step 2: Install dependencies
Ensure `docx` module is installed in the working directory:
```bash
npm install docx
```

### Step 3: Run the script
Execute the script to generate the .docx file.

### Step 4: Deliver the document
Move the generated document to the outputs folder for user access.

## Document Template

Use this template for creating PsAccelerator branded documents:

```javascript
const fs = require('fs');
const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, 
        AlignmentType, HeadingLevel, BorderStyle, WidthType, ShadingType, 
        VerticalAlign, LevelFormat, ExternalHyperlink } = require('docx');

// PsAccelerator brand colors
const brandGreen = "008000";
const lightGreen = "D5F0D5";
const darkGray = "333333";
const black = "000000";

// Table borders
const tableBorder = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
const cellBorders = { top: tableBorder, bottom: tableBorder, left: tableBorder, right: tableBorder };

const doc = new Document({
  styles: {
    default: { 
      document: { run: { font: "Arial", size: 22 } }
    },
    paragraphStyles: [
      { 
        id: "Title", 
        name: "Title", 
        basedOn: "Normal",
        run: { size: 48, bold: true, color: brandGreen, font: "Arial" },
        paragraph: { spacing: { before: 0, after: 240 }, alignment: AlignmentType.CENTER }
      },
      { 
        id: "Heading1", 
        name: "Heading 1", 
        basedOn: "Normal", 
        next: "Normal", 
        quickFormat: true,
        run: { size: 32, bold: true, color: brandGreen, font: "Arial" },
        paragraph: { spacing: { before: 360, after: 180 }, outlineLevel: 0 }
      },
      { 
        id: "Heading2", 
        name: "Heading 2", 
        basedOn: "Normal", 
        next: "Normal", 
        quickFormat: true,
        run: { size: 26, bold: true, color: darkGray, font: "Arial" },
        paragraph: { spacing: { before: 240, after: 120 }, outlineLevel: 1 }
      }
    ]
  },
  numbering: {
    config: [
      { 
        reference: "bullet-list",
        levels: [
          { 
            level: 0, 
            format: LevelFormat.BULLET, 
            text: "•", 
            alignment: AlignmentType.LEFT,
            style: { paragraph: { indent: { left: 720, hanging: 360 } } }
          }
        ]
      }
    ]
  },
  sections: [{
    properties: {
      page: { margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } }
    },
    children: [
      // TITLE
      new Paragraph({
        heading: HeadingLevel.TITLE,
        children: [new TextRun("PsAccelerator")]
      }),
      
      new Paragraph({
        alignment: AlignmentType.CENTER,
        spacing: { after: 360 },
        children: [new TextRun({ 
          text: "Het bieden van de snelste weg naar een oplossing",
          italics: true,
          size: 24,
          color: darkGray
        })]
      }),

      // CONTENT SECTIONS
      // Add your document content here following the brand guidelines
      
      // Example heading
      new Paragraph({
        heading: HeadingLevel.HEADING_1,
        children: [new TextRun("Your Section Title")]
      }),

      // Example body text
      new Paragraph({
        spacing: { after: 180 },
        children: [new TextRun("Your content goes here...")]
      }),

      // Example bullet list
      new Paragraph({
        numbering: { reference: "bullet-list", level: 0 },
        children: [new TextRun("First bullet point")]
      }),

      // Example table with brand colors
      new Table({
        columnWidths: [3120, 6240],
        margins: { top: 100, bottom: 100, left: 180, right: 180 },
        rows: [
          new TableRow({
            tableHeader: true,
            children: [
              new TableCell({
                borders: cellBorders,
                width: { size: 3120, type: WidthType.DXA },
                shading: { fill: lightGreen, type: ShadingType.CLEAR },
                verticalAlign: VerticalAlign.CENTER,
                children: [new Paragraph({ 
                  alignment: AlignmentType.CENTER,
                  children: [new TextRun({ text: "Column 1", bold: true, size: 24 })]
                })]
              }),
              new TableCell({
                borders: cellBorders,
                width: { size: 6240, type: WidthType.DXA },
                shading: { fill: lightGreen, type: ShadingType.CLEAR },
                verticalAlign: VerticalAlign.CENTER,
                children: [new Paragraph({ 
                  alignment: AlignmentType.CENTER,
                  children: [new TextRun({ text: "Column 2", bold: true, size: 24 })]
                })]
              })
            ]
          }),
          new TableRow({
            children: [
              new TableCell({
                borders: cellBorders,
                width: { size: 3120, type: WidthType.DXA },
                children: [new Paragraph({ children: [new TextRun("Data 1")] })]
              }),
              new TableCell({
                borders: cellBorders,
                width: { size: 6240, type: WidthType.DXA },
                children: [new Paragraph({ children: [new TextRun("Data 2")] })]
              })
            ]
          })
        ]
      }),

      // FOOTER with contact info
      new Paragraph({
        spacing: { before: 480 },
        children: [new TextRun({ text: "Contact", bold: true, size: 28 })]
      }),

      new Paragraph({
        spacing: { after: 120 },
        children: [
          new TextRun({ text: "Website: ", bold: true }),
          new ExternalHyperlink({
            children: [new TextRun({ text: "psaccelerator.nl", style: "Hyperlink" })],
            link: "https://psaccelerator.nl"
          })
        ]
      }),

      new Paragraph({
        spacing: { after: 120 },
        children: [
          new TextRun({ text: "Email: ", bold: true }),
          new TextRun("info@psaccelerator.nl")
        ]
      }),

      new Paragraph({
        spacing: { before: 360 },
        alignment: AlignmentType.CENTER,
        children: [new TextRun({ 
          text: "PsAccelerator - Uw partner in automatisering sinds 2006",
          size: 20,
          color: darkGray,
          italics: true
        })]
      })
    ]
  }]
});

// Generate and save
Packer.toBuffer(doc).then(buffer => {
  fs.writeFileSync("output-filename.docx", buffer);
  console.log("Document created successfully!");
});
```

## Quick Reference


### Common Document Types

**Company Brochure**
- Title with PsAccelerator logo styling
- Services section with bullet points
- Why choose us table with green headers
- Contact information footer

**Technical Proposal**
- Green title and section headers
- Problem/solution structure
- Technical specifications in tables
- Timeline with bullet points

**Service Overview**
- Main services as H1 sections
- Sub-services as H2 sections
- Feature lists with bullets
- Pricing or comparison tables

**Meeting Minutes/Reports**
- Date and attendees in table
- Agenda items as H2 headings
- Action items with bullets
- Next steps section

### Formatting Guidelines

**Spacing**
- Title: 0 before, 240 after
- H1: 360 before, 180 after
- H2: 240 before, 120 after
- Body paragraphs: 180 after
- Lists: 240 after last item

**Tables**
- Use light green (#D5F0D5) for headers
- Gray borders (#CCCCCC)
- Bold text in header cells
- Letter page with 1" margins = 9360 DXA total width

**Color Usage**
- Green (#008000): Titles, H1 headings, branding elements
- Dark Gray (#333333): H2 headings, secondary text
- Black (#000000): Body text
- Light Green (#D5F0D5): Table headers, subtle backgrounds


## Example Workflow

```
User: "Create a PsAccelerator document about our automation services"

1. Create working directory if needed
2. Create JavaScript file with template
3. Customize content sections:
   - Services offered
   - Benefits and features
   - Contact information
4. Install docx if not available: npm install docx
5. Run script: node script.js
6. Move document to outputs for user download
```

## Best Practices

1. **Always use Arial font** - It's the brand standard
2. **Use green for main headings** - Establishes brand identity
3. **Keep design clean** - Adequate white space, not cluttered
4. **Use tables for structured data** - With light green headers
5. **Include contact info** - Website and email at the end
6. **Consistent spacing** - Follow the spacing guidelines above
7. **Professional tone** - Match the Dutch language style when applicable

## Common Elements

### Standard Header
```javascript
new Paragraph({
  heading: HeadingLevel.TITLE,
  children: [new TextRun("PsAccelerator")]
}),
new Paragraph({
  alignment: AlignmentType.CENTER,
  spacing: { after: 360 },
  children: [new TextRun({ 
    text: "Het bieden van de snelste weg naar een oplossing",
    italics: true,
    size: 24,
    color: darkGray
  })]
})
```

### Standard Footer
```javascript
new Paragraph({
  spacing: { before: 360 },
  alignment: AlignmentType.CENTER,
  children: [new TextRun({ 
    text: "PsAccelerator - Uw partner in automatisering sinds 2006",
    size: 20,
    color: darkGray,
    italics: true
  })]
})
```
