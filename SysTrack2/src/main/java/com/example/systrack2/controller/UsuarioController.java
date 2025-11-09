package com.example.systrack2.controller;

import com.example.systrack2.DTO.Request.UsuarioRequestDTO;
import com.example.systrack2.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/usuarios")
@RequiredArgsConstructor
public class UsuarioController {

    private final UsuarioService usuarioService;

    @GetMapping("/cadastrar-se")
    public String cadastrarForm(Model model) {
        model.addAttribute("usuario", new UsuarioRequestDTO());
        return "usuarios/cadastrar-se";
    }

    @PostMapping("/cadastrar-se")
    public String cadastrar(@ModelAttribute("usuario") UsuarioRequestDTO dto) {
        usuarioService.criar(dto);
        return "redirect:/login?success"; // volta pro login depois do cadastro
    }

    @GetMapping("/listar")
    public String listar(Model model) {
        model.addAttribute("usuarios", usuarioService.listar());
        return "usuarios/listar";
    }

    @GetMapping("/gerenciar")
    public String gerenciar(Model model) {
        model.addAttribute("usuarios", usuarioService.listar());
        return "usuarios/gerenciar";
    }

    @GetMapping("/editar/{id}")
    public String editarForm(@PathVariable Long id, Model model) {
        var usuarioResponse = usuarioService.buscarPorId(id);

        // Criar DTO para edição (sem senha)
        UsuarioRequestDTO dto = new UsuarioRequestDTO();
        dto.setNome(usuarioResponse.getNome());
        dto.setEmail(usuarioResponse.getEmail());
        dto.setRole(usuarioResponse.getRole());

        model.addAttribute("usuario", dto);
        model.addAttribute("usuarioId", id); // ID separado para o action do form
        return "usuarios/editar";
    }

    @PostMapping("/editar/{id}")
    public String editar(@PathVariable Long id, @ModelAttribute("usuario") UsuarioRequestDTO dto) {
        usuarioService.atualizar(id, dto);
        return "redirect:/usuarios/gerenciar";
    }


    @GetMapping("/excluir/{id}")
    public String excluir(@PathVariable Long id) {
        usuarioService.excluir(id);
        return "redirect:/usuarios/gerenciar";
    }
}