#!/usr/bin/env python3
"""
Report Directory Structure Creator

Creates standardized directory structure for Claude-generated reports.
Usage:
    python create_report_structure.py [skill_name]
    python create_report_structure.py Update
    python create_report_structure.py Analysis
"""

import os
import sys
from datetime import datetime
from pathlib import Path


def create_report_structure(skill_name="Update", base_tmp="C:\\tmp"):
    """
    Create standardized report directory structure.
    
    Args:
        skill_name: Name of the skill/project (default: "Update")
        base_tmp: Base temporary directory (default: "C:\\tmp")
    
    Returns:
        Dictionary with paths to created directories
    """
    # Get current date in YYYYMMDD format
    date_stamp = datetime.now().strftime("%Y%m%d")
    
    # Build directory paths
    base_path = Path(base_tmp) / "Claude" / skill_name / date_stamp
    data_path = base_path / "data"
    assets_path = base_path / "assets"
    
    # Create directories
    base_path.mkdir(parents=True, exist_ok=True)
    data_path.mkdir(exist_ok=True)
    assets_path.mkdir(exist_ok=True)
    
    paths = {
        "base": str(base_path),
        "data": str(data_path),
        "assets": str(assets_path),
        "date_stamp": date_stamp
    }
    
    print(f"[OK] Created report structure:")
    print(f"   Base: {paths['base']}")
    print(f"   Data: {paths['data']}")
    print(f"   Assets: {paths['assets']}")
    
    return paths


def main():
    """Main entry point for command-line usage."""
    skill_name = sys.argv[1] if len(sys.argv) > 1 else "Update"
    
    try:
        paths = create_report_structure(skill_name)
        print(f"\nReport directory ready at:")
        print(f"   {paths['base']}")
        return 0
    except Exception as e:
        print(f"[ERROR] Error creating directory structure: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
