#  Fails randomly.
#
#
#  require 'spec_helper'
#
#  feature 'Upload Images Through Tinymce',  type: :feature do
#    before :each do
#      @article = Fabricate(:blog_article)
#      @project = Fabricate(:blog_project)
#      @project_leader = Fabricate(:user, roles: [:project_leader])
#    end
#
#    after :all do
#      @article.destroy
#      @project.destroy
#    end
#
#    scenario 'image upload is disabled on create', js: true do
#      pending "works. Tested manually - martin"
#      sign_in(@project_leader)
#      visit new_admin_blog_article_path
#
#      within(:css, '.mce-tinymce .mce-container.mce-toolbar') do
#        expect(page).not_to have_css('.mce-ico.mce-i-image')
#      end
#    end
#
#    scenario 'image upload is loaded on edit', js: true do
#      pending "works. Tested manually - martin"
#      sign_in(@project_leader)
#      visit edit_admin_blog_article_path(@article)
#
#      within(:css, '.mce-tinymce .mce-container.mce-toolbar') do
#        expect(page).to have_css('.mce-ico.mce-i-image')
#      end
#    end
#
#    scenario 'uploaded images are shown bellow', js: true do
#      #pending "works. Tested manually - martin"
#      sign_in(@project_leader)
#      visit edit_admin_blog_article_path(@article)
#
#      first(:css, '.mce-ico.mce-i-image').click
#      #click_link_or_button '.mce-ico.mce-i-image'
#      attach_file 'file',
#                "#{Rails.root}/spec/fabricators/test_assets/mann3-frontpage.jpg",
#                visible: false
#      click_link_or_button 'Insert'
#      first('input[type="submit"]').click
#
#      visit edit_admin_blog_article_path(@article)
#
#      within(:css, '.has_many_container.blog_images') do
#        expect do
#          blog_image_url = @article.blog_images.last.image.url(:small)
#          page.to have_css('img[src="' + blog_image_url + '"]')
#        end
#      end
#    end
#  end
