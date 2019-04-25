<?php
class CartpopupproductOverride extends Cartpopupproduct
{
    public function getCartProducts($id_lang, $active = true, $id_product)
    {
		$product = new Product((int)$id_product);
        $sql = 'SELECT p.*, product_shop.*, stock.out_of_stock, IFNULL(stock.quantity, 0) as quantity, pl.`description`, pl.`description_short`, pl.`link_rewrite`,
					pl.`meta_description`, pl.`meta_keywords`, pl.`meta_title`, pl.`name`, pl.`available_now`, pl.`available_later`,
					pai.`id_image` id_image, il.`legend`, m.`name` as manufacturer_name, cl.`name` AS category_default, IFNULL(product_attribute_shop.id_product_attribute, 0) id_product_attribute,
					DATEDIFF(
						p.`date_add`,
						DATE_SUB(
							"'.date('Y-m-d').' 00:00:00",
							INTERVAL '.(Validate::isUnsignedInt(Configuration::get('PS_NB_DAYS_NEW_PRODUCT')) ? Configuration::get('PS_NB_DAYS_NEW_PRODUCT') : 20).' DAY
						)
					) > 0 AS new
				FROM `'._DB_PREFIX_.'cartpopupproduct` c
				LEFT JOIN `'._DB_PREFIX_.'product` p ON p.`id_product` = c.`id_product_2`
				'.Shop::addSqlAssociation('product', 'p').'
				LEFT JOIN `'._DB_PREFIX_.'product_lang` pl ON (
					p.`id_product` = pl.`id_product`
					AND pl.`id_lang` = '.(int)$id_lang.Shop::addSqlRestrictionOnLang('pl').'
				)
				LEFT JOIN `'._DB_PREFIX_.'product_attribute` pa ON (c.`id_pro_attribute` = pa.`id_product_attribute` && c.`id_product_2` = pa.`id_product`)
					'.Shop::addSqlAssociation('product_attribute', 'pa').'
					LEFT JOIN `'._DB_PREFIX_.'product_attribute_combination` pac ON pac.`id_product_attribute` = pa.`id_product_attribute`
					LEFT JOIN `'._DB_PREFIX_.'attribute` a ON a.`id_attribute` = pac.`id_attribute`
					LEFT JOIN `'._DB_PREFIX_.'attribute_group` ag ON ag.`id_attribute_group` = a.`id_attribute_group`
					LEFT JOIN `'._DB_PREFIX_.'attribute_lang` al ON (a.`id_attribute` = al.`id_attribute` AND al.`id_lang` = '.(int)$id_lang.')
					LEFT JOIN `'._DB_PREFIX_.'attribute_group_lang` agl ON (ag.`id_attribute_group` = agl.`id_attribute_group` AND agl.`id_lang` = '.(int)$id_lang.')
					LEFT JOIN `'._DB_PREFIX_.'product_attribute_image` pai ON pai.`id_product_attribute` = pa.`id_product_attribute`
				LEFT JOIN `'._DB_PREFIX_.'product_attribute_shop` pas
					ON (p.`id_product` = pas.`id_product` AND pas.`default_on` = 1 AND pas.id_shop='.(int)Context::getContext()->shop->id.')
				LEFT JOIN `'._DB_PREFIX_.'category_lang` cl ON (
					product_shop.`id_category_default` = cl.`id_category`
					AND cl.`id_lang` = '.(int)$id_lang.Shop::addSqlRestrictionOnLang('cl').'
				)
				LEFT JOIN `'._DB_PREFIX_.'image_shop` image_shop
					ON (image_shop.`id_product` = p.`id_product` AND image_shop.cover=1 AND image_shop.id_shop='.(int)Context::getContext()->shop->id.')
				LEFT JOIN `'._DB_PREFIX_.'image_lang` il ON (image_shop.`id_image` = il.`id_image` AND il.`id_lang` = '.(int)$id_lang.')
				LEFT JOIN `'._DB_PREFIX_.'manufacturer` m ON (p.`id_manufacturer`= m.`id_manufacturer`)
				'.Product::sqlStock('p', 0).'
				WHERE c.`id_product_1` = '.(int)$product->id.
                ($active ? ' AND product_shop.`active` = 1 AND product_shop.`visibility` != \'none\'' : '').'
				GROUP BY c.id_pro_attribute LIMIT 0, 3';
		$result = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($sql);
		$withoutCom = Db::getInstance()->executeS('
			SELECT p.*, pl.`link_rewrite`, pl.`name`,stock.out_of_stock, IFNULL(stock.quantity, 0) as quantity
			FROM `'._DB_PREFIX_.'cartpopupproduct`
			LEFT JOIN `'._DB_PREFIX_.'product` p ON (p.`id_product`= `id_product_2`)
			'.Shop::addSqlAssociation('product', 'p').'
			LEFT JOIN `'._DB_PREFIX_.'product_lang` pl ON (
				p.`id_product` = pl.`id_product`
				AND pl.`id_lang` = '.(int)$id_lang.Shop::addSqlRestrictionOnLang('pl').'
			)
			LEFT JOIN `'._DB_PREFIX_.'manufacturer` m ON (p.`id_manufacturer`= m.`id_manufacturer`)
				'.Product::sqlStock('p', 0).'
			WHERE `id_product_1` = '.(int)$id_product.' AND `id_pro_attribute` = 0'
        );
        foreach ($result as $key => $value) {
        	$result[$key]['cartpopupproduct'] = true;
        }

        foreach($withoutCom as $pro_id => $norpro)
        {
        	$img = Image::getImages($id_lang,$norpro['id_product']);
            if(is_array($img) && !empty($img)){
            	if($norpro['id_product'] == 8){
            		$withoutCom[$pro_id]['id_image'] = $img[1]['id_image'];
            	}else{
            		$withoutCom[$pro_id]['id_image'] = $img[0]['id_image'];
            	}
                
            }
            else{
                $withoutCom[$pro_id]['id_image'] = 0;
            }
        	$withoutCom[$pro_id]['id_product_attribute'] = 0;
        }
        $result = array_merge($result,$withoutCom);

        if (!$result) {

            if (isset($product->id_category_default) && $product->id_category_default > 1)
				$category = new Category((int)$product->id_category_default);
			if (!Validate::isLoadedObject($category) || !$category->active)
				return false;
			$result = $category->getProducts($this->context->language->id, 1, 3);
			
			// Remove current product from the list
			if (is_array($result) && count($result))
			{
				foreach ($result as $key => $category_product)
				{
					if ($category_product['id_product'] == $id_product)
					{
						unset($result[$key]);
						break;
					}
				}

				$taxes = Product::getTaxCalculationMethod();
				if (Configuration::get('PRODUCTSCATEGORY_DISPLAY_PRICE'))
				{
					foreach ($result as $key => $category_product)
					{
						if ($category_product['id_product'] != $id_product)
						{
							if ($taxes == 0 || $taxes == 2)
							{
								$result[$key]['displayed_price'] = Product::getPriceStatic(
									(int)$category_product['id_product'],
									true,
									null,
									2
								);
							} elseif ($taxes == 1)
							{
								$result[$key]['displayed_price'] = Product::getPriceStatic(
									(int)$category_product['id_product'],
									false,
									null,
									2
								);
							}
						}
					}
				}                
			} else {
				return false;
			}
        }

        return $product->getProductsProperties($id_lang, $result);
    }

    public function getCartProductsAjax($id_product)
	{
		$cart_product = array();
		$cart_product = $this->getCartProducts($this->context->language->id, true, $id_product);
        if (version_compare(_PS_VERSION_, '1.6.0', '>=') === true)
			$this->context->controller->addColorsToProductList($cart_product);
		//print_r($cart_product); exit();
        foreach ($cart_product as $key => $category_product){
			$product = new Product($category_product['id_product'], true, $this->context->language->id);
			if (($product->is_pacifier && $product->count_pacifier > 0)|| $product->id == 8) {
				if (isset($this->context->cookie->customized_product_data))
				{
					$cpd = json_decode($this->context->cookie->customized_product_data);
					if(isset($cpd->name) && $cpd->name !='' && ($product->id == 8 || $product->icon_button == 1)){
						$emoji = array("/ª/","/ƒ/","/∆/","/¬/","/Ω/","/…/","/√/","/∫/","/µ/","/°/","/∑/","/®/","/†/","/¥/","/˚/","/|/","/œ/","/π/","/¡/","/∞/","/™/","/¶/","/≠/","/±/","/¯/","/ˇ/","/ﬁ/","/¢/","/‰/","/◊/","/≈/","/•/");
						// $string = explode("\n", $cpd->name);
						$replacement = '';
						$cpd->name = preg_replace($emoji, $replacement, $cpd->name);
					}
					if(isset($cpd->name) && $cpd->name !='')
						{
							$DATA ='';
							if($product->character_limit == 0)
								$product->character_limit = 9;
							$string = explode("\n", $cpd->name, 3);
							$x = count($string)-1;
							if($x >= $product->limit_textarea-1)
								$x = $product->limit_textarea-1;
							foreach($string as $i => $v)
							{
								$v = substr($v,0,$product->character_limit);
								if($i<= $x){
									if($i<$x)
									$DATA .=$v.'%0A';
								else
									$DATA .=$v;
								}
							}
							$cpd->name = $DATA;
						}
						else
						{
							$customizeDataForNon = array();
							$customizeDataForNon['name'] = '';
							$customizeDataForNon['font'] = '';
							$new = json_encode($customizeDataForNon);
							$cpd = json_decode($new);
						}
					$cart_product[$key]['customized_product_data'] = $cpd;
					$cart_product[$key]['customized_product_data']->font = Tools::getValue('font');
					$cart_product[$key]['font'] = Tools::getValue('font');
				}
				
			}
		}

		if(is_array($cart_product))
		{
			$link = new Link();
			foreach ($cart_product as $key => $cart_pdt) {
				/*Color_group*/
				$id_shop = $this->context->shop->id;
				$id_lang = $this->context->language->id;
				$sql_attributes = 'Select ppas.default_on, pac.*, pa.id_attribute_group, pag.group_type, pal.name, pa.color,agl.`name` AS group_name,pal.`name` AS attribute_name
					FROM '._DB_PREFIX_.'product_attribute_shop ppas
					LEFT JOIN '._DB_PREFIX_.'product_attribute_combination pac ON (pac.id_product_attribute = ppas.id_product_attribute)
					LEFT JOIN '._DB_PREFIX_.'attribute pa ON (pac.id_attribute = pa.id_attribute)
					LEFT JOIN '._DB_PREFIX_.'attribute_shop pas ON (pa.id_attribute = pas.id_attribute)
					LEFT JOIN '._DB_PREFIX_.'attribute_lang pal ON (pa.id_attribute = pal.id_attribute and pal.id_lang = '.$id_lang.')
					LEFT JOIN '._DB_PREFIX_.'attribute_group pag ON (pa.id_attribute_group = pag.id_attribute_group)
					LEFT JOIN '._DB_PREFIX_.'attribute_group_shop pags ON (pag.id_attribute_group = pags.id_attribute_group)
					LEFT JOIN `'._DB_PREFIX_.'attribute_group_lang` agl ON (pag.`id_attribute_group` = agl.`id_attribute_group` AND agl.`id_lang` = '.(int)$id_lang.')
					where ppas.id_product = '.$cart_pdt['id_product'].'
					AND ppas.id_product_attribute = '.$cart_pdt['id_product_attribute'].'
					AND ppas.id_shop = '.$id_shop.'
					AND pa.id_attribute_group IN (1,3,5)
					AND pas.id_shop = '.$id_shop.'
					AND pags.id_shop = '.$id_shop.'                
					GROUP BY pa.id_attribute
					ORDER BY pa.position ASC';
				$result_att = Db::getInstance()->executeS($sql_attributes);
				$p_link = $link->getProductLink($cart_pdt['id_product'], $cart_pdt['link_rewrite'], $cart_pdt['category'], null, null, null, $cart_pdt['id_product_attribute'],false,false,true);
		        $ex = explode('#',$p_link);
		        if(count($ex) > 1)
		        	$addL = $ex[0].'?c=1#'.$ex[1];
		    	else
		    		$addL = $ex[0].'?c=1';
		        $cart_product[$key]['link'] = $addL;
		        
				$color_array = array();
				$size_array = array();
				$material_array = array();
				$i = 0;
				$pro = new Product($cart_pdt['id_product'],true,$this->context->language->id,$this->context->shop->id);
				$cart_product[$key]['max_w1'] = $pro->max_w1;
				$cart_product[$key]['max_w2'] = $pro->max_w2;
				$cart_product[$key]['max_w3'] = $pro->max_w3;
				$cart_product[$key]['max_h1'] = $pro->max_h1;
				$cart_product[$key]['max_h2'] = $pro->max_h2;
				$cart_product[$key]['max_h3'] = $pro->max_h3;
				if (!empty($result_att)) {                
					foreach ($result_att as $value) {                    
						if ($value['id_attribute_group'] == 3) {

							$sql_image_attributes = 'SELECT pai.id_image
                            FROM '._DB_PREFIX_.'product_attribute_image pai
                            LEFT JOIN '._DB_PREFIX_.'image paii ON paii.id_image = pai.id_image
                            where pai.id_product_attribute = '.$value['id_product_attribute'].'
                            ORDER BY paii.position ASC LIMIT 1';
                        
                        	$result_att_image = Db::getInstance()->executeS($sql_image_attributes);

							$color_array[$i]['name'] = $value['name'];
							$color_array[$i]['color'] = $value['color'];
							if (!empty($result_att_image)) { 
								if($cart_pdt['id_product'] == 8){
									$color_array[$i]['id_image'] = $result_att_image[1]['id_image'];
								}else{
									$color_array[$i]['id_image'] = $result_att_image[0]['id_image'];
								}
	                            
	                        }
	                        else
	                        {
	                            $color_array[$i]['id_image'] = '';
	                        }
							$i++;
						} elseif ($value['id_attribute_group'] == 5) {                        
							$material_array[] = $value['name'];
						} elseif ($value['id_attribute_group'] == 1) {                        
							$size_array[] = $value['name'];
						}
					}
				}
				if(empty($color_array))
				{
					$imgg = $pro->getImages($this->context->language->id);
					if(!empty($imgg)){
						if($cart_pdt['id_product'] == 8){
							$cart_product[$key]['color_array'][] = $imgg[1];
						}else{
							$cart_product[$key]['color_array'][] = $imgg[0];
						}
					}else{
						$cart_product[$key]['color_array'][] = '';
					}
					
				}
				else
				$cart_product[$key]['color_array'] = $color_array;
			
				$cart_product[$key]['size_array'] = (empty($size_array) ? '' : implode(', ', $size_array));
				$cart_product[$key]['material_array'] = (empty($material_array) ? '' : implode(', ', $material_array));
				
				$query = 'SELECT * FROM `' . _DB_PREFIX_ . 'product_customised_area` WHERE `id_product`="'.$cart_pdt['id_product'].'" ORDER BY `set`';
				$customised_values = Db::getInstance()->ExecuteS($query);
				if(!empty($customised_values))
					$cart_product[$key]['customised_values'] = $customised_values;
			}
		}
		$this->smarty->assign('font', Tools::getValue('font'));
		$this->smarty->assign('text', Tools::getValue('name1'));
		$this->smarty->assign('products', $cart_product);
		$this->smarty->assign('homeSize', Image::getSize(ImageType::getFormatedName('home')));		
		return $this->display(__FILE__, 'product-list.tpl');
	}
    
}
