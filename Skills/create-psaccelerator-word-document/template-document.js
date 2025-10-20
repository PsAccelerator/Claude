/**
 * PsAccelerator Word Document Template
 * 
 * This is a complete, ready-to-use template for creating branded
 * PsAccelerator Word documents using the docx library.
 * 
 * Usage:
 * 1. Ensure docx is installed: npm install docx
 * 2. Customize the content in the sections array
 * 3. Run: node template-document.js
 * 
 * Brand Colors:
 * - Brand Green: #008000 (titles, H1)
 * - Light Green: #D5F0D5 (table headers)
 * - Dark Gray: #333333 (H2, secondary text)
 * - Black: #000000 (body text)
 */

const fs = require('fs');
const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, 
        AlignmentType, HeadingLevel, BorderStyle, WidthType, ShadingType, 
        VerticalAlign, LevelFormat, ExternalHyperlink } = require('docx');

// ==================== BRAND COLORS ====================
const brandGreen = "008000";
const lightGreen = "D5F0D5";
const darkGray = "333333";
const black = "000000";
const lightGray = "CCCCCC";

// ==================== TABLE BORDERS ====================
const tableBorder = { style: BorderStyle.SINGLE, size: 1, color: lightGray };
const cellBorders = { 
  top: tableBorder, 
  bottom: tableBorder, 
  left: tableBorder, 
  right: tableBorder 
};

// ==================== DOCUMENT DEFINITION ====================
const doc = new Document({
  styles: {
    default: { 
      document: { run: { font: "Arial", size: 22 } }
    },
    paragraphStyles: [
      // Title style - brand green, centered
      { 
        id: "Title", 
        name: "Title", 
        basedOn: "Normal",
        run: { size: 48, bold: true, color: brandGreen, font: "Arial" },
        paragraph: { spacing: { before: 0, after: 240 }, alignment: AlignmentType.CENTER }
      },
      // Heading 1 - brand green, bold
      { 
        id: "Heading1", 
        name: "Heading 1", 
        basedOn: "Normal", 
        next: "Normal", 
        quickFormat: true,
        run: { size: 32, bold: true, color: brandGreen, font: "Arial" },
        paragraph: { spacing: { before: 360, after: 180 }, outlineLevel: 0 }
      },
      // Heading 2 - dark gray, bold
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
      page: {
        margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 }
      }
    },
    children: [
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
      new Paragraph({
        heading: HeadingLevel.HEADING_1,
        children: [new TextRun("Over PsAccelerator")]
      }),
      new Paragraph({
        spacing: { after: 180 },
        children: [new TextRun("PsAccelerator is sinds 2006 actief in het ontwikkelen en implementeren van software. Wij zijn gespecialiseerd in automatiseringsoplossingen met gebruik van Microsoft-technologieën.")]
      }),
      new Paragraph({
        spacing: { after: 360 },
        children: [new TextRun("Door gebruik te maken van een speciale methodiek lost PsAccelerator uw automatiseringsproblemen snel en efficiënt op.")]
      }),
      new Paragraph({
        heading: HeadingLevel.HEADING_1,
        children: [new TextRun("Onze Diensten")]
      }),
      new Paragraph({
        heading: HeadingLevel.HEADING_2,
        children: [new TextRun("Automatisering")]
      }),
      new Paragraph({
        spacing: { after: 180 },
        children: [new TextRun("Wij bieden complete automatiseringsoplossingen die uw bedrijfsprocessen optimaliseren.")]
      }),
      new Paragraph({
        numbering: { reference: "bullet-list", level: 0 },
        children: [new TextRun("Procesautomatisering")]
      }),
      new Paragraph({
        numbering: { reference: "bullet-list", level: 0 },
        children: [new TextRun("Workflow optimalisatie")]
      }),
