with Ada.Unchecked_Deallocation;
with PB_Support.IO;
with PB_Support.Internal;

package body Google.Protobuf.Compiler.Plugin is

   package File_Descriptor_Proto_IO is
     new PB_Support.IO.Message_IO
       (Google.Protobuf.Descriptor.File_Descriptor_Proto,
        Google.Protobuf.Descriptor.File_Descriptor_Proto_Vector,
        Google.Protobuf.Descriptor.Append);

   package File_IO is
     new PB_Support.IO.Message_IO
       (Google.Protobuf.Compiler.Plugin.File,
        Google.Protobuf.Compiler.Plugin.File_Vector,
        Google.Protobuf.Compiler.Plugin.Append);

   function Length (Self : Code_Generator_Request_Vector) return Natural is
   begin
      return Self.Length;
   end Length;

   function Get
    (Self  : Code_Generator_Request_Vector;
     Index : Positive)
      return Code_Generator_Request is
   begin
      return Self.Data (Index);
   end Get;

   procedure Clear (Self : in out Code_Generator_Request_Vector) is
   begin
      Self.Length := 0;
   end Clear;

   procedure Free is new Ada.Unchecked_Deallocation
     (Code_Generator_Request_Array, Code_Generator_Request_Array_Access);

   procedure Append
    (Self  : in out Code_Generator_Request_Vector;
     Value : Code_Generator_Request) is
      Init_Length : constant Positive :=
        Positive'Max (1, 256 / Code_Generator_Request'Size);
   begin
      if Self.Length = 0 then
         Self.Data :=  new Code_Generator_Request_Array (1 .. Init_Length);

      elsif Self.Length = Self.Data'Last then
         Self.Data :=
           new Code_Generator_Request_Array'
             (Self.Data.all
                & Code_Generator_Request_Array'(1 .. Self.Length => <>));
      end if;
      Self.Length := Self.Length + 1;
      Self.Data (Self.Length) := Value;
   end Append;

   overriding procedure Adjust (Self : in out Code_Generator_Request_Vector) is
   begin
      if Self.Length > 0 then
         Self.Data :=
           new Code_Generator_Request_Array'(Self.Data (1 .. Self.Length));
      end if;
   end Adjust;

   overriding procedure Finalize
    (Self : in out Code_Generator_Request_Vector) is
   begin
      if Self.Data /= null then
         Free (Self.Data);
      end if;
   end Finalize;

   procedure Read_Code_Generator_Request
    (Stream : access Ada.Streams.Root_Stream_Type'Class;
     Value  : out Code_Generator_Request) is
      Key : aliased PB_Support.IO.Key;
   begin
      while PB_Support.IO.Read_Key (Stream, Key'Access) loop
         case Key.Field is
            when 1 =>
               PB_Support.IO.Read_Universal_String_Vector
                 (Stream, Key.Encoding, Value.File_To_Generate);
            when 2 =>
               PB_Support.IO.Read_Universal_String
                 (Stream, Key.Encoding, Value.Parameter);
            when 15 =>
               File_Descriptor_Proto_IO.Read_Vector
                 (Stream, Key.Encoding, Value.Proto_File);
            when others =>
               PB_Support.IO.Unknown_Field (Stream, Key.Encoding);
         end case;
      end loop;
   end Read_Code_Generator_Request;

   procedure Write_Code_Generator_Request
    (Stream : access Ada.Streams.Root_Stream_Type'Class;
     Value  : Code_Generator_Request) is
   begin
      if Stream.all not in PB_Support.Internal.Stream then
         declare
            WS : aliased PB_Support.Internal.Stream (Stream);
         begin
            Write_Code_Generator_Request (WS'Access, Value);
            return;
         end;
      end if;
      declare
         WS : PB_Support.Internal.Stream renames
           PB_Support.Internal.Stream (Stream.all);
      begin
         WS.Start_Message;
         WS.Write (1, Value.File_To_Generate);
         WS.Write (2, Value.Parameter);
         for J in 1 .. Value.Proto_File.Length loop
            WS.Write_Key ((15, PB_Support.Length_Delimited));
            Google.Protobuf.Descriptor.File_Descriptor_Proto'Write
              (Stream, Value.Proto_File.Get (J));
         end loop;
         if WS.End_Message then
            Write_Code_Generator_Request (WS'Access, Value);
         end if;
      end;
   end Write_Code_Generator_Request;

   function Length (Self : Code_Generator_Response_Vector) return Natural is
   begin
      return Self.Length;
   end Length;

   function Get
    (Self  : Code_Generator_Response_Vector;
     Index : Positive)
      return Code_Generator_Response is
   begin
      return Self.Data (Index);
   end Get;

   procedure Clear (Self : in out Code_Generator_Response_Vector) is
   begin
      Self.Length := 0;
   end Clear;

   procedure Free is new Ada.Unchecked_Deallocation
     (Code_Generator_Response_Array, Code_Generator_Response_Array_Access);

   procedure Append
    (Self  : in out Code_Generator_Response_Vector;
     Value : Code_Generator_Response) is
      Init_Length : constant Positive :=
        Positive'Max (1, 256 / Code_Generator_Response'Size);
   begin
      if Self.Length = 0 then
         Self.Data :=  new Code_Generator_Response_Array (1 .. Init_Length);

      elsif Self.Length = Self.Data'Last then
         Self.Data :=
           new Code_Generator_Response_Array'
             (Self.Data.all
                & Code_Generator_Response_Array'(1 .. Self.Length => <>));
      end if;
      Self.Length := Self.Length + 1;
      Self.Data (Self.Length) := Value;
   end Append;

   overriding procedure Adjust
    (Self : in out Code_Generator_Response_Vector) is
   begin
      if Self.Length > 0 then
         Self.Data :=
           new Code_Generator_Response_Array'(Self.Data (1 .. Self.Length));
      end if;
   end Adjust;

   overriding procedure Finalize
    (Self : in out Code_Generator_Response_Vector) is
   begin
      if Self.Data /= null then
         Free (Self.Data);
      end if;
   end Finalize;

   procedure Read_Code_Generator_Response
    (Stream : access Ada.Streams.Root_Stream_Type'Class;
     Value  : out Code_Generator_Response) is
      Key : aliased PB_Support.IO.Key;
   begin
      while PB_Support.IO.Read_Key (Stream, Key'Access) loop
         case Key.Field is
            when 1 =>
               PB_Support.IO.Read_Universal_String
                 (Stream, Key.Encoding, Value.Error);
            when 15 =>
               File_IO.Read_Vector (Stream, Key.Encoding, Value.File);
            when others =>
               PB_Support.IO.Unknown_Field (Stream, Key.Encoding);
         end case;
      end loop;
   end Read_Code_Generator_Response;

   procedure Write_Code_Generator_Response
    (Stream : access Ada.Streams.Root_Stream_Type'Class;
     Value  : Code_Generator_Response) is
   begin
      if Stream.all not in PB_Support.Internal.Stream then
         declare
            WS : aliased PB_Support.Internal.Stream (Stream);
         begin
            Write_Code_Generator_Response (WS'Access, Value);
            return;
         end;
      end if;
      declare
         WS : PB_Support.Internal.Stream renames
           PB_Support.Internal.Stream (Stream.all);
      begin
         WS.Start_Message;
         WS.Write (1, Value.Error);
         for J in 1 .. Value.File.Length loop
            WS.Write_Key ((15, PB_Support.Length_Delimited));
            Google.Protobuf.Compiler.Plugin.File'Write
              (Stream, Value.File.Get (J));
         end loop;
         if WS.End_Message then
            Write_Code_Generator_Response (WS'Access, Value);
         end if;
      end;
   end Write_Code_Generator_Response;

   function Length (Self : File_Vector) return Natural is
   begin
      return Self.Length;
   end Length;

   function Get (Self  : File_Vector; Index : Positive) return File is
   begin
      return Self.Data (Index);
   end Get;

   procedure Clear (Self : in out File_Vector) is
   begin
      Self.Length := 0;
   end Clear;

   procedure Free is new Ada.Unchecked_Deallocation
     (File_Array, File_Array_Access);

   procedure Append (Self  : in out File_Vector; Value : File) is
      Init_Length : constant Positive := Positive'Max (1, 256 / File'Size);
   begin
      if Self.Length = 0 then
         Self.Data :=  new File_Array (1 .. Init_Length);

      elsif Self.Length = Self.Data'Last then
         Self.Data :=
           new File_Array'
             (Self.Data.all & File_Array'(1 .. Self.Length => <>));
      end if;
      Self.Length := Self.Length + 1;
      Self.Data (Self.Length) := Value;
   end Append;

   overriding procedure Adjust (Self : in out File_Vector) is
   begin
      if Self.Length > 0 then
         Self.Data := new File_Array'(Self.Data (1 .. Self.Length));
      end if;
   end Adjust;

   overriding procedure Finalize (Self : in out File_Vector) is
   begin
      if Self.Data /= null then
         Free (Self.Data);
      end if;
   end Finalize;

   procedure Read_File
    (Stream : access Ada.Streams.Root_Stream_Type'Class;
     Value  : out File) is
      Key : aliased PB_Support.IO.Key;
   begin
      while PB_Support.IO.Read_Key (Stream, Key'Access) loop
         case Key.Field is
            when 1 =>
               PB_Support.IO.Read_Universal_String
                 (Stream, Key.Encoding, Value.Name);
            when 2 =>
               PB_Support.IO.Read_Universal_String
                 (Stream, Key.Encoding, Value.Insertion_Point);
            when 15 =>
               PB_Support.IO.Read_Universal_String
                 (Stream, Key.Encoding, Value.Content);
            when others =>
               PB_Support.IO.Unknown_Field (Stream, Key.Encoding);
         end case;
      end loop;
   end Read_File;

   procedure Write_File
    (Stream : access Ada.Streams.Root_Stream_Type'Class;
     Value  : File) is
   begin
      if Stream.all not in PB_Support.Internal.Stream then
         declare
            WS : aliased PB_Support.Internal.Stream (Stream);
         begin
            Write_File (WS'Access, Value);
            return;
         end;
      end if;
      declare
         WS : PB_Support.Internal.Stream renames
           PB_Support.Internal.Stream (Stream.all);
      begin
         WS.Start_Message;
         WS.Write (1, Value.Name);
         WS.Write (2, Value.Insertion_Point);
         WS.Write (15, Value.Content);
         if WS.End_Message then
            Write_File (WS'Access, Value);
         end if;
      end;
   end Write_File;

end Google.Protobuf.Compiler.Plugin;