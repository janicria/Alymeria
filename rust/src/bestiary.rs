use godot::prelude::*;
use godot::global::Error;
use godot::classes::{Control, IControl, ColorRect, Label, RichTextLabel, Sprite2D, Texture2D, InputEvent};

#[derive(GodotClass)]
#[class(base=Control)]
struct Bestiary {
    color_rect: Gd<ColorRect>,
    sprite_2d: Gd<Sprite2D>,
    base: Base<Control>
}

#[godot_api]
impl IControl for Bestiary {
    fn init(base: Base <Control>) -> Self {
        Self {
            color_rect: ColorRect::new_alloc(),
            sprite_2d: Sprite2D::new_alloc(),
            base,
        }
    }

    fn ready(&mut self) {
        // Setting up nodes
        self.color_rect = self
        .base()
        .get_node_as::<ColorRect>("%ColorRect");
        self.sprite_2d = self
        .base()
        .get_node_as::<Sprite2D>("%Icon");

        // Connecting Signals
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
    fn show_menu(&mut self, items: Array<Variant>, shop_text: bool) {
        // Visibility
        self.base_mut().show();
        self.color_rect.show();
        self
        .base()
        .get_node_as::<Label>("%ShopText")
        .set_visible(shop_text);

        // Text
        self
        .base()
        .get_node_as::<RichTextLabel>("%Title").
        set_text(format!("[center][font_size=32]{0}[/font_size][/center]", items.at(0).stringify()).to_godot());
        self
        .base()
        .get_node_as::<RichTextLabel>("%Description")
        .set_text(format!("[center]{0}[/center]", items.at(2).stringify()).to_godot());
        self
        .base()
        .get_node_as::<RichTextLabel>("%Footer")
        .set_text(format!("[center]{0}[/center]", items.at(3).stringify()).to_godot());

        // Icon
        self.sprite_2d.set_texture(items.at(1).to::<Gd<Texture2D>>());
        self.sprite_2d.set_scale( // 16px = 4 scale. 32px = 2 scale
             Vector2 { x: (64.0), y: (64.0) } / items.at(1).to::<Gd<Texture2D>>().get_size());
    }

    #[func]
    fn on_color_rect_gui_input(&mut self, event: Gd<InputEvent>) {
        if event.is_action_pressed("left_mouse".into()) {
            self.base_mut().hide();
        }
    }
}
