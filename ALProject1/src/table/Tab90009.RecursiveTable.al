table 90009 "RecursiveTable"
{
    DataClassification = ToBeClassified;
    Caption = 'RecursiveTable';

    fields
    {
        field(1; Item; Code[30])
        {
            Caption = 'Item';
        }
        field(2; Parent; code[30])
        {
            Caption = 'Parent';
        }
    }

    keys
    {
        key(Key1; Item) // PK RecursiveTable
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}