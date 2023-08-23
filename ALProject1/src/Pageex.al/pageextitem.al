pageextension 90000 "pex_item" extends "Inventory Setup"
{
    layout
    {
        addafter("Item Nos.")
        {
            field("Document No"; Rec."Document No")
            {
                Caption = 'Document No';
                ApplicationArea = All;
            }
        }
    }
}