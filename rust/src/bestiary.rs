use godot::prelude::*;
use godot::global::Error;
use godot::classes::{Control, IControl, ColorRect, Label, RichTextLabel, Sprite2D, Texture2D, InputEvent};


#[derive(GodotClass)]
#[class(base=Control)]
struct Bestiary {
    color_rect: Gd<ColorRect>,
    base: Base<Control>
}

#[godot_api]
impl IControl for Bestiary {
    fn init(base: Base <Control>) -> Self {
        Self {
            color_rect: ColorRect::new_alloc(),
            base,
        }
    }
    fn ready(&mut self) {
        self.color_rect = self
        .base()
        .get_node_as::<ColorRect>("%ColorRect");

        match self.color_rect.get_parent() {
            Some(mut parent) => {
            self.color_rect.connect(
                "gui_input".into(), Callable::from_object_method(&parent, "on_color_rect_gui_input"));
            parent.connect(
                "visibility_changed".into(), Callable::from_object_method(&self.color_rect, "hide"))},

            None => Error::ERR_DOES_NOT_EXIST
        };
    }

    fn input(&mut self, event: Gd<InputEvent>) {
        if event.is_action_released("ui_cancel".into()) {
            self.base_mut().hide();
        }
    }
}


#[godot_api]
impl Bestiary {
    #[func]
    fn show_menu(&mut self, items: Array<Variant>, shop_text: bool) {//>icon: Gd<Texture2D>, title: GString, description: GString, footer: GString, shop_text: bool) {
        self.base_mut().show();
        self
        .base()
        .get_node_as::<Label>("%ShopText")
        .set_visible(shop_text);

        self
        .base()
        .get_node_as::<RichTextLabel>("%Title").
        set_text(format!("[center][font_size=32]{0}[/font_size][/center]", items.at(0).stringify()).to_godot());
        self
        .base()
        .get_node_as::<Sprite2D>("%Icon")
        .set_texture(items.at(1).to::<Gd<Texture2D>>());
        self
        .base()
        .get_node_as::<RichTextLabel>("%Description")
        .set_text(format!("[center]{0}[/center]", items.at(2).stringify()).to_godot());
        self
        .base()
        .get_node_as::<RichTextLabel>("%Footer")
        .set_text(format!("[center]{0}[/center]", items.at(3).stringify()).to_godot());
    }

    #[func]
    fn on_color_rect_gui_input(&mut self, event: Gd<InputEvent>) {
        if event.is_action_pressed("left_mouse".into()) {
            self.base_mut().hide();
        }
    }
}
