tableextension 90000 "tex_item" extends "Inventory Setup"
{
    fields
    {
        field(50200; "Document No"; Code[20])
        {
            Caption = '"Document No';
            TableRelation = "No. Series";
        }
    }
}